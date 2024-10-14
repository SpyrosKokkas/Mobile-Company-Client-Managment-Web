package com.example.finaljavaweb.finaljavaweb;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private static final int ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("role") != null) {
            String role = (String) session.getAttribute("role");
            if ("seller".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/sellerIndex.jsp");
            } else if ("admin".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/adminIndex.jsp");
            } else if ("client".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/clientIndex.jsp");
            }
        } else {
            RequestDispatcher dispatcher = req.getRequestDispatcher("login.jsp");
            dispatcher.forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        String action = req.getParameter("action");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;



        try {
            conn = DatabaseUtil.getConnection();

            if (conn != null) {
                if ("login".equals(action)) {
                    String sql = "SELECT password, salt, role, client_id FROM users WHERE username = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, username);

                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        String storedHash = rs.getString("password");
                        String saltHex = rs.getString("salt");
                        byte[] salt = hexStringToByteArray(saltHex);
                        String role = rs.getString("role");
                        Integer clientId = (Integer) rs.getObject("client_id");

                        if (validatePassword(password, storedHash, salt)) {
                            HttpSession session = req.getSession();
                            session.setAttribute("username", username);
                            session.setAttribute("userRole", role);

                            if ("seller".equals(role)) {
                                resp.sendRedirect(req.getContextPath() + "/sellerIndex");
                            } else if ("admin".equals(role)) {
                                resp.sendRedirect(req.getContextPath() + "/adminIndex");
                            } else if ("client".equals(role)) {
                                if (clientId==null) {
                                    resp.sendRedirect("matchAFM.jsp");
                                } else {
                                    session.setAttribute("client_id", clientId);
                                    resp.sendRedirect(req.getContextPath() + "/clientIndex");
                                }
                            } else {
                                resp.sendRedirect("login.jsp");
                            }
                        } else {
                            out.println("<h1>Invalid username or password!</h1>");
                        }
                    } else {
                        out.println("<h1>Invalid username or password!</h1>");
                    }
                } else if ("register".equals(action)) {
                    String role = "client";
                    boolean registrationSuccess = CreateUsers.registerUser(username, password, role);

                    if (registrationSuccess) {
                        out.println("<h1>Επιτυχής Εγγραφή! Παρακαλώ Συνδεθείτε</h1>");
                    } else {
                        out.println("<h1>Registration failed! Please try again.</h1>");
                    }
                }
            } else {
                out.println("<h1>Database connection failed!</h1>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private static boolean validatePassword(String originalPassword, String storedHash, byte[] salt) throws NoSuchAlgorithmException, InvalidKeySpecException {
        String hashedOriginal = hashPassword(originalPassword, salt);
        return storedHash.equals(hashedOriginal);
    }

    private static String hashPassword(String password, byte[] salt) throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        byte[] hash = factory.generateSecret(spec).getEncoded();
        return Base64.getEncoder().encodeToString(hash);
    }

    private static byte[] hexStringToByteArray(String hexString) {
        int len = hexString.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hexString.charAt(i), 16) << 4)
                    + Character.digit(hexString.charAt(i + 1), 16));
        }
        return data;
    }
}
