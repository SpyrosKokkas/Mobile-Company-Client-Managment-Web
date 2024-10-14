package com.example.finaljavaweb.finaljavaweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "AdminServlet", value = "/adminAction")
public class AdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            String username = request.getParameter("username");
            String newRole = request.getParameter("role");

            boolean success = Admin.editUser(username, newRole);

            if (success) {
                String message = URLEncoder.encode("Επιτυχής τροποποίηση ρόλου χρήστη", StandardCharsets.UTF_8);
                response.sendRedirect("manageUsers.jsp?message=" + message);
            } else {
                String error = URLEncoder.encode("Αποτυχία τροποποίησης ρόλου χρήστη", StandardCharsets.UTF_8);
                response.sendRedirect("manageUsers.jsp?error=" + error);
            }
        } else if ("delete".equals(action)) {
            String username = request.getParameter("username");

            boolean success = Admin.deleteUser(username);

            if (success) {
                String message = URLEncoder.encode("Επιτυχής διαγραφή χρήστη", StandardCharsets.UTF_8);
                response.sendRedirect("manageUsers.jsp?message=" + message);
            } else {
                String error = URLEncoder.encode("Αποτυχία διαγραφής χρήστη", StandardCharsets.UTF_8);
                response.sendRedirect("manageUsers.jsp?error=" + error);
            }

        } else if ("addPackage".equals(action)) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            float price = Float.parseFloat(request.getParameter("price"));

            boolean success = Admin.addPackage(name, description, price);

            if (success) {
                String message = URLEncoder.encode("Το πρόγραμματα δημιουργήθηκε επιτυχώς", StandardCharsets.UTF_8);
                response.sendRedirect("AdminPackageEdit.jsp?message=" + message);
            } else {
                String error = URLEncoder.encode("Αποτυχία", StandardCharsets.UTF_8);
                response.sendRedirect("AdminPackageEdit.jsp?error=" + error);
            }
        } else if ("editPackage".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            Float price = priceStr != null && !priceStr.isEmpty() ? Float.parseFloat(priceStr) : null;

            boolean success = Admin.editPackage(id, name, description, price);

            if (success) {
                String message = URLEncoder.encode("Επιτυχής ενημέρωση προγράμματος", StandardCharsets.UTF_8);
                response.sendRedirect("AdminPackageEdit.jsp?message=" + message);
            } else {
                String error = URLEncoder.encode("αποτυχια", StandardCharsets.UTF_8);
                response.sendRedirect("AdminPackageEdit.jsp?error=" + error);
            }
        } else if ("deletePackage".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));

            boolean success = Admin.deletePackage(id);

            if (success) {
                String message = URLEncoder.encode("Επιτυχής Διαγραφή Προγράμματος", StandardCharsets.UTF_8);
                response.sendRedirect("AdminPackageEdit.jsp?message=" + message);
            } else {
                String error = URLEncoder.encode("Αποτυχία", StandardCharsets.UTF_8);
                response.sendRedirect("AdminPackageEdit.jsp?error=" + error);
            }
        }else if ("logout".equals(action)){
            response.sendRedirect("login.jsp");
            request.getSession().invalidate();

        }
    }
}
