<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.finaljavaweb.finaljavaweb.DatabaseUtil" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    if ( !userRole.equals("admin") ) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, String>> users = new ArrayList<>();
    try (Connection conn = DatabaseUtil.getConnection()) {
        String sql = "SELECT username, role FROM users";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> user = new HashMap<>();
                user.put("username", rs.getString("username"));
                user.put("role", rs.getString("role"));
                users.add(user);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            position: relative;
        }

        h1, h2 {
            color: #444;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .actions {
            text-align: center;
        }

        .actions form {
            display: inline-block;
        }

        .actions select {
            margin-right: 5px;
        }

        .logout-back-container {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .logout-button {
            padding: 10px 5px;
            background: #d9534f;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            width: 90px;
        }

        .logout-button:hover {
            background: #c9302c;
        }

        .back-button {
            padding: 8px 5px;
            background: #5bc0de;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            width: 90px;
        }
        th {
            background-color: #5c85d6;
            color: #fff;
        }
        .back-button:hover {
            background: #31b0d5;
        }

        .message {
            background-color: #dff0d8;
            color: #3c763d;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #d6e9c6;
            border-radius: 4px;
            display: none;
        }

        .error {
            background-color: #f2dede;
            color: #a94442;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ebccd1;
            border-radius: 4px;
            display: none;
        }
    </style>
</head>
<body>
<div class="logout-back-container">
    <form action="adminAction" method="post" style="margin: 0; padding: 0;">
        <input type="hidden" name="action" value="logout">
        <button type="submit" class="logout-button">Αποσύνδεση</button>
    </form>
    <form action="adminIndex" style="margin: 0; padding: 0;">
        <button type="submit" class="back-button">Επιστροφή</button>
    </form>
</div>

<div class="container">
    <h1>Διαχείριση Χρηστών</h1>

    <c:if test="${not empty param.message}">
        <div class="message">${param.message}</div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="error">${param.error}</div>
    </c:if>

    <table>
        <tr>
            <th>Όνομα Χρήστη</th>
            <th>Ρόλος</th>
            <th>Ενέργειες</th>
        </tr>
        <%
            for (Map<String, String> user : users) {
        %>
        <tr>
            <td><%= user.get("username") %></td>
            <td class="role-cell" id="<%= user.get("username") %>">
                <%= user.get("role") %>
                <form class="edit-form" style="display: none;" action="adminAction" method="post">
                    <input type="hidden" name="username" value="<%= user.get("username") %>">
                    <label>
                        <select name="role">
                            <option value="seller" <%= "Seller".equals(user.get("role")) ? "selected" : "" %>>Seller</option>
                            <option value="client" <%= "Client".equals(user.get("role")) ? "selected" : "" %>>Client</option>
                            <option value="admin" <%= "Admin".equals(user.get("role")) ? "selected" : "" %>>Admin</option>
                        </select>
                    </label>
                    <input type="hidden" name="action" value="edit">
                    <button type="submit">Αποθήκευση</button>
                </form>
            </td>
            <td class="actions">
                <button class="edit-button" onclick="showEditForm('<%= user.get("username") %>')">Επεξεργασία</button>
                <form style="display: inline-block;" action="adminAction" method="post">
                    <input type="hidden" name="username" value="<%= user.get("username") %>">
                    <input type="hidden" name="action" value="delete">
                    <button type="submit" class="delete-button">Διαγραφή</button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</div>

<script>
    function showEditForm(username) {
        document.querySelectorAll('.edit-form').forEach(function(form) {
            form.style.display = 'none';
        });
        document.getElementById(username).querySelector('.edit-form').style.display = 'inline-block';
    }

    function displaySuccessMessage() {
        var message = document.querySelector('.message');
        if (message.textContent.trim() !== '') {
            message.style.display = 'block';
        }
    }

    function displayErrorMessage() {
        var error = document.querySelector('.error');
        if (error.textContent.trim() !== '') {
            error.style.display = 'block';
        }
    }

    displaySuccessMessage();
    displayErrorMessage();
</script>
</body>
</html>