<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.finaljavaweb.finaljavaweb.DatabaseUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Telephony Packages</title>
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
            background: #fff;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 15px;
            text-align: left;
        }
        th {
            background-color: #5c85d6;
            color: #fff;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
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

        .back-button:hover {
            background: #31b0d5;
        }

        .form-container {
            display: none;
            margin-top: 20px;
            padding: 20px;
            padding-top: 10px;
            border: 1px solid #ddd;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .button-container {
            margin-bottom: 20px;
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
    <script>
        function showForm(formId) {
            var forms = document.getElementsByClassName('form-container');
            for (var i = 0; i < forms.length; i++) {
                forms[i].style.display = 'none';
            }
            document.getElementById(formId).style.display = 'block';
        }

        function setEditFormData(id, name, description, price) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-description').value = description;
            document.getElementById('edit-price').value = price;
        }

        function setDeleteFormData(id) {
            document.getElementById('delete-id').value = id;
        }
    </script>
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
    <h1>Διαθέσιμα Πακέτα Τηλεφωνίας</h1>

    <c:if test="${not empty param.message}">
        <div class="message">${param.message}</div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="error">${param.error}</div>
    </c:if>

    <h2>Προσθήκη νέου προγράμματος</h2>
    <div class="button-container">
        <button onclick="showForm('add-form')">Δημιουργία Προγράμματος</button>
    </div>
    <div id="add-form" class="form-container">
        <form action="adminAction" method="post">
            <input type="hidden" name="action" value="addPackage">
            <label for="name">Όνομα</label>
            <input type="text" id="name" name="name" required>
            <label for="description">Περιγραφή</label>
            <input type="text" id="description" name="description" required>
            <label for="price">Τιμή</label>
            <input type="number" step="0.01" id="price" name="price" required>
            <button type="submit">Δημιουργία Προγράμαμτος</button>
        </form>
    </div>

    <table>
        <tr>
            <th>Κωδικός</th>
            <th>Όνομα</th>
            <th>Περιγραφή</th>
            <th>Τιμή</th>
            <th>Ενέργειες</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                conn = DatabaseUtil.getConnection();
                stmt = conn.createStatement();
                String query = "SELECT * FROM packages ORDER BY id ASC";  // Sorting by id in ascending order
                rs = stmt.executeQuery(query);

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String description = rs.getString("description");
                    float price = rs.getFloat("price");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= description %></td>
            <td><%= price %></td>
            <td>
                <button onclick="showForm('edit-form'); setEditFormData(<%= id %>, '<%= name %>', '<%= description %>', <%= price %>)">Επεξεργασία</button>
                <button onclick="showForm('delete-form'); setDeleteFormData(<%= id %>)">Διαγραφή</button>
            </td>
        </tr>
        <%
                }
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
        %>
    </table>
    <script>
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
    <div id="edit-form" class="form-container">
        <h2>Επεξεργασία Πακέτου</h2>
        <form action="adminAction" method="post">
            <input type="hidden" name="action" value="editPackage">
            <input type="hidden" id="edit-id" name="id" required>
            <label for="name">Όνομα</label>
            <input type="text" id="edit-name" name="name">
            <label for="description">Περιγραφή</label>
            <input type="text" id="edit-description" name="description">
            <label for="price">Τιμή</label>
            <input type="number" step="0.01" id="edit-price" name="price">
            <button type="submit">Ενημέρωση</button>
        </form>
    </div>

    <div id="delete-form" class="form-container">
        <h2>Θέλετε Σίγουρα να Διαγράψετε το συγκερκιμένο πρόγραμμα; </h2>
        <form action="adminAction" method="post">
            <input type="hidden" name="action" value="deletePackage">
            <input type="hidden" id="delete-id" name="id" required>
            <button type="submit">Επιβεβαίωση Διαγραφής</button>
        </form>
    </div>
</div>
</body>
</html>
