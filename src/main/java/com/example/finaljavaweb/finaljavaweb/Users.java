package com.example.finaljavaweb.finaljavaweb;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;




public class Users {
    String username;
    String name;
    String surname;
    String userRole;
    static int userCount = 0;

    public Users(String username, String name, String surname, String userRole) {
        this.username = username;
        this.name = name;
        this.surname = surname;
        this.userRole = userRole;
        userCount++;
    }

    public Users() {

    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String register(){
        return "Registered";
    }

    public String login () {
        return "Successfully logged in";
    }
}

class Client extends Users {

    String phoneNumber;
    private static final Logger LOGGER = Logger.getLogger(Client.class.getName());

    public Client() {}

    public void viewBills(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String clientIdParam = request.getParameter("clientId");

        LOGGER.log(Level.INFO, "Parameters received - Client ID: {0}", clientIdParam);

        if (clientIdParam == null || clientIdParam.isEmpty()) {
            response.sendRedirect("clientIndex?error=Invalid input parameters");
            return;
        }

        int clientId = 0;

        try {
            clientId = Integer.parseInt(clientIdParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid clientId format", e);
            String error = URLEncoder.encode("Invalid clientId format", StandardCharsets.UTF_8);
            response.sendRedirect("clientIndex.jsp?error=" + error);
            return;
        }

        try (Connection connection = DatabaseUtil.getConnection()) {
            String sql = "SELECT * FROM Bills WHERE client_id = ? ORDER BY bill_id DESC ";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, clientId);
            ResultSet resultSet = statement.executeQuery();

            StringBuilder tableBuilder = new StringBuilder();
            tableBuilder.append("<table>");
            tableBuilder.append("<tr><th>Κωδικός Λογαριασμού</th><th>Ημερομηνία Έκδοσης</th><th>Ποσό</th><th>Κατάσταση</th><th>Ενέργειες</th></tr>");
            while (resultSet.next()) {
                tableBuilder.append("<tr>");
                tableBuilder.append("<td>").append(resultSet.getInt("bill_id")).append("</td>");
                tableBuilder.append("<td>").append(resultSet.getDate("bill_date")).append("</td>");
                tableBuilder.append("<td>").append(resultSet.getDouble("amount")).append("</td>");
                tableBuilder.append("<td>").append(resultSet.getString("status")).append("</td>");
                tableBuilder.append("<td>");
                if (!"Εξοφλήθηκε".equals(resultSet.getString("status"))) {
                    tableBuilder.append("<form action='paymentPage.jsp' method='post'>");
                    tableBuilder.append("<input type='hidden' name='billId' value='").append(resultSet.getInt("bill_id")).append("'>");
                    tableBuilder.append("<button type='submit'>Πληρωμή</button>");
                    tableBuilder.append("</form>");
                }
                tableBuilder.append("</td>");
                tableBuilder.append("</tr>");
            }
            tableBuilder.append("</table>");

            request.setAttribute("bills", tableBuilder.toString());
            RequestDispatcher dispatcher = request.getRequestDispatcher("viewBills.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error while retrieving bills", e);
            String error = URLEncoder.encode("Error while retrieving bills", StandardCharsets.UTF_8);
            response.sendRedirect("clientIndex.jsp?error=" + error);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    public void matchAFM (HttpServletResponse response, HttpServletRequest request) {
        String afm = request.getParameter("afm");
        String username = (String) request.getSession().getAttribute("username");

        try (Connection connection = DatabaseUtil.getConnection()) {
            String sql = "SELECT clientid FROM clients WHERE afm = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, afm);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                int clientId = resultSet.getInt("clientid");
                String sqlUpdate = "UPDATE users SET client_id = ? WHERE username = ?";
                PreparedStatement updateStatement = connection.prepareStatement(sqlUpdate);
                updateStatement.setInt(1, clientId);
                updateStatement.setString(2, username);
                int rowsUpdated = updateStatement.executeUpdate();

                if (rowsUpdated > 0) {
                    request.getSession().setAttribute("client_id", clientId);
                    response.sendRedirect("clientIndex");
                } else {
                    response.sendRedirect("matchAFM.jsp");
                }
            } else {
                response.sendRedirect("matchAFM.jsp");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error while matching AFM", e);
            String error = URLEncoder.encode("Error while matching AFM", StandardCharsets.UTF_8);
            try {
                response.sendRedirect("clientIndex?error=" + error);
            } catch (IOException ioException) {
                LOGGER.log(Level.SEVERE, "Error while redirecting", ioException);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public void viewCallHistory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT call_date, call_duration " +
                    "FROM call_history " +
                    "WHERE client_id = (SELECT client_id FROM users WHERE username = ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                ResultSet rs = pstmt.executeQuery();

                StringBuilder callHistory = new StringBuilder();
                callHistory.append("<table><tr><th>Ημερομηνία</th><th>Διάρκεια (Δευτερόλεπτα)</th></tr>");

                while (rs.next()) {
                    String callDate = rs.getString("call_date");
                    int duration = rs.getInt("call_duration");
                    callHistory.append("<tr><td>").append(callDate).append("</td><td>")
                            .append(duration).append("</td></tr>");
                }

                callHistory.append("</table>");

                request.setAttribute("callHistory", callHistory.toString());
                request.getRequestDispatcher("clientViewCallHistory.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            String error = URLEncoder.encode("Database error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("clientIndex.jsp?error=" + error);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
            String error = URLEncoder.encode("Unexpected error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("clientIndex.jsp?error=" + error);
        }
    }

    public void payBill(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String billIdParam = req.getParameter("billId");
        Integer clientIdInt = (Integer) req.getSession().getAttribute("client_id");

        if (billIdParam == null || clientIdInt == null) {
            resp.sendRedirect("clientIndex?error=Invalid bill or client ID");
            return;
        }

        int billId;
        int clientId = clientIdInt;

        try {
            billId = Integer.parseInt(billIdParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid billId format", e);
            String error = URLEncoder.encode("Invalid billId format", StandardCharsets.UTF_8);
            resp.sendRedirect("clientIndex?error=" + error);
            return;
        }

        try (Connection connection = DatabaseUtil.getConnection()) {
            String sql = "UPDATE Bills SET status = 'Εξοφλήθηκε' WHERE bill_id = ? AND client_id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, billId);
            statement.setInt(2, clientId);
            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated > 0) {
                String message = URLEncoder.encode("Bill successfully paid", StandardCharsets.UTF_8);
                resp.sendRedirect("clientIndex?message=" + message);
            } else {
                String error = URLEncoder.encode("Failed to update bill status", StandardCharsets.UTF_8);
                resp.sendRedirect("clientIndex?error=" + error);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "SQL error while updating bill status", e);
            String error = URLEncoder.encode("SQL error while updating bill status", StandardCharsets.UTF_8);
            resp.sendRedirect("clientIndex?error=" + error);
        }
    }
}

class Seller extends Users {
    private static final Logger LOGGER = Logger.getLogger(Seller.class.getName());

    public Seller() {
        super("", "", "", "seller");
    }

    public Seller(String username, String name, String surname, String userRole) {
        super(username, name, surname, userRole);
    }

    public void insertCustomer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("customerName");
        String surname = request.getParameter("surname");
        String userRole = "client";
        String afmParam = request.getParameter("AFM");
        String phoneNumber = request.getParameter("customerPhone");

        LOGGER.log(Level.INFO, "Parameters received - Name: {0}, Surname: {1}, AFM: {2}, Phone: {3}",
                new Object[]{name, surname, afmParam, phoneNumber});

        int AFM = 0;
        if (afmParam != null && !afmParam.isEmpty()) {
            try {
                AFM = Integer.parseInt(afmParam);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.SEVERE, "Invalid AFM format", e);
            }
        }

        if (name == null || name.isEmpty() ||
                surname == null || surname.isEmpty() ||
                phoneNumber == null || phoneNumber.isEmpty()) {
            response.sendRedirect("sellerIndex?error=Invalid input parameters");
            return;
        }

        boolean success = CreateUsers.createNewClient(name, surname, AFM, phoneNumber, userRole);

        if (success) {
            String message = URLEncoder.encode("Επιτυχής προσθήκη πελάτη", StandardCharsets.UTF_8);
            response.sendRedirect("sellerIndex?message=" + message);
        } else {
            String error = URLEncoder.encode("Αποτυχία προσθήκης πελάτη", StandardCharsets.UTF_8);
            response.sendRedirect("sellerIndex?error=" + error);
        }
    }

    public void assignPackage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clientIdParam = request.getParameter("clientId");
        String packageIdParam = request.getParameter("packageId");

        LOGGER.log(Level.INFO,
                "Parameters received - Client ID: {0}, Package ID: {1}",
                new Object[]{clientIdParam,
                        packageIdParam});

        if (clientIdParam == null || clientIdParam.isEmpty() || packageIdParam == null || packageIdParam.isEmpty()) {
            response.sendRedirect("sellerIndex?error=Invalid input parameters");
            return;
        }

        int clientId = 0;
        int packageId = 0;

        try {
            clientId = Integer.parseInt(clientIdParam);
            packageId = Integer.parseInt(packageIdParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid clientId or packageId format", e);
            String error = URLEncoder.encode("Invalid clientId or packageId format", StandardCharsets.UTF_8);
            response.sendRedirect("sellerIndex?error=" + error);
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "UPDATE clients SET package_id = ? WHERE clientid = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, packageId);
                pstmt.setInt(2, clientId);
                int rowsUpdated = pstmt.executeUpdate();

                if (rowsUpdated > 0) {
                    String message = URLEncoder.encode("Επιτυχής Εγγραφή", StandardCharsets.UTF_8);
                    response.sendRedirect("sellerIndex?message=" + message);
                } else {
                    String error = URLEncoder.encode("Πελάτης δεν βρέθηκε", StandardCharsets.UTF_8);
                    response.sendRedirect("sellerIndex?error=" + error);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            String error = URLEncoder.encode("Database error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("sellerIndex?error=" + error);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
            String error = URLEncoder.encode("Unexpected error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("sellerIndex?error=" + error);
        }
    }

    void issueBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clientIdParam = request.getParameter("clientId");

        LOGGER.log(Level.INFO, "Parameters received - Client ID: {0}", new Object[]{clientIdParam});

        if (clientIdParam == null || clientIdParam.isEmpty()) {
            response.sendRedirect("viewCustomers.jsp?error=Invalid input parameters");
            return;
        }

        int clientId = 0;

        try {
            clientId = Integer.parseInt(clientIdParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid clientId format", e);
            String error = URLEncoder.encode("Invalid clientId format", StandardCharsets.UTF_8);
            response.sendRedirect("viewCustomers.jsp?error=" + error);
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT c.clientname, c.clientsurname, p.price " +
                    "FROM clients c " +
                    "INNER JOIN packages p ON c.package_id = p.id " +
                    "WHERE c.clientid = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, clientId);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    String clientName = rs.getString("clientname");
                    String clientSurname = rs.getString("clientsurname");
                    double packagePrice = rs.getDouble("price");
                    String status = "Εκκρεμής";

                    insertBill(clientId, packagePrice, status);

                    String message = URLEncoder.encode("Εκδόθηκε ο λογαριασμός για τον πελάτη " + clientName + " " + clientSurname + " με τελικό ποσό " + packagePrice, StandardCharsets.UTF_8);
                    response.sendRedirect("viewCustomers.jsp?message=" + message);
                } else {
                    String error = URLEncoder.encode("Client not found", StandardCharsets.UTF_8);
                    response.sendRedirect("viewCustomers.jsp?error=" + error);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            String error = URLEncoder.encode("Database error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("viewCustomers.jsp?error=" + error);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
            String error = URLEncoder.encode("Unexpected error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("viewCustomers.jsp?error=" + error);
        }
    }

    private void insertBill(int clientId, double billAmount, String status) throws Exception {
        try (Connection conn = DatabaseUtil.getConnection()) {
            String insertSql = "INSERT INTO bills (client_id, amount, status) VALUES (?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setInt(1, clientId);
                insertStmt.setDouble(2, billAmount);
                insertStmt.setString(3, status);
                insertStmt.executeUpdate();
            }
        }
    }


    public void viewCallHistory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clientIdParam = request.getParameter("clientId");

        LOGGER.log(Level.INFO, "Parameters received - Client ID: {0}", clientIdParam);

        if (clientIdParam == null || clientIdParam.isEmpty()) {
            response.sendRedirect("viewCustomers.jsp?error=Invalid input parameters");
            return;
        }

        int clientId = 0;

        try {
            clientId = Integer.parseInt(clientIdParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid clientId format", e);
            String error = URLEncoder.encode("Invalid clientId format", StandardCharsets.UTF_8);
            response.sendRedirect("viewCustomers.jsp?error=" + error);
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT call_date, call_duration " +
                    "FROM call_history " +
                    "WHERE client_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, clientId);
                ResultSet rs = pstmt.executeQuery();

                StringBuilder callHistory = new StringBuilder();
                callHistory.append("<table><tr><th>Ημερομηνία</th><th>Διάρκεια ( Δευτερόλεπτα )</th></tr>");

                while (rs.next()) {
                    String callDate = rs.getString("call_date");
                    int duration = rs.getInt("call_duration");
                    callHistory.append("<tr><td>").append(callDate).append("</td><td>")
                            .append(duration).append("</td></tr>");
                }

                callHistory.append("</table>");

                request.setAttribute("callHistory", callHistory.toString());
                request.getRequestDispatcher("viewCallHistory.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            String error = URLEncoder.encode("Database error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("viewCustomers.jsp?error=" + error);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
            String error = URLEncoder.encode("Unexpected error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("viewCustomers.jsp?error=" + error);
        }
    }

}

class Admin extends Users {

    public Admin(String username, String name, String surname, String userRole) {
        super(username, name, surname, userRole);
    }

    public Admin() {
        super();
    }

    public static boolean editUser(String username, String userRole) {
        try {
            Connection conn = DatabaseUtil.getConnection();
            if (conn != null) {
                String sql = "UPDATE users SET role = ? WHERE username = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, userRole);
                stmt.setString(2, username);
                int rowsAffected = stmt.executeUpdate();
                stmt.close();
                conn.close();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean deleteUser(String username) {
        try {
            Connection conn = DatabaseUtil.getConnection();
            if (conn != null) {
                String sql = "DELETE FROM users WHERE username = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                int rowsDeleted = stmt.executeUpdate();
                stmt.close();
                conn.close();
                return rowsDeleted > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public static boolean addPackage(String name, String description, float price) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            String queryMaxId = "SELECT MAX(id) AS maxId FROM packages";
            stmt = conn.prepareStatement(queryMaxId);
            rs = stmt.executeQuery();
            int nextId = 1;
            if (rs.next()) {
                nextId = rs.getInt("maxId") + 1;
            }

            String insertQuery = "INSERT INTO packages (id, name, description, price) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, nextId);
            stmt.setString(2, name);
            stmt.setString(3, description);
            stmt.setFloat(4, price);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return false;
    }
    public static boolean editPackage(int id, String name, String description, Float price) {
        try {
            Connection conn = DatabaseUtil.getConnection();
            if (conn != null) {
                StringBuilder sql = new StringBuilder("UPDATE packages SET ");
                boolean hasPrev = false;

                if (name != null && !name.isEmpty()) {
                    sql.append("name = ?");
                    hasPrev = true;
                }

                if (description != null && !description.isEmpty()) {
                    if (hasPrev) sql.append(", ");
                    sql.append("description = ?");
                    hasPrev = true;
                }

                if (price != null) {
                    if (hasPrev) sql.append(", ");
                    sql.append("price = ?");
                }

                sql.append(" WHERE id = ?");

                PreparedStatement stmt = conn.prepareStatement(sql.toString());
                int paramIndex = 1;

                if (name != null && !name.isEmpty()) {
                    stmt.setString(paramIndex++, name);
                }

                if (description != null && !description.isEmpty()) {
                    stmt.setString(paramIndex++, description);
                }

                if (price != null) {
                    stmt.setFloat(paramIndex++, price);
                }

                stmt.setInt(paramIndex, id);

                int rowsAffected = stmt.executeUpdate();
                stmt.close();
                conn.close();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean deletePackage(int id) {
        try {
            Connection conn = DatabaseUtil.getConnection();
            if (conn != null) {
                String sql = "DELETE FROM packages WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, id);
                int rowsDeleted = stmt.executeUpdate();
                stmt.close();
                conn.close();
                return rowsDeleted > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }



}