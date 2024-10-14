<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    if ( !userRole.equals("seller") ) {
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
        .bill-button, .history-button {
            padding: 5px 10px;
            background: #d9534f;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            position: absolute;
            top: 10px;
            right: 10px;
            display: inline-block;
            width: 70px;
            margin-top: 5px;
        }

        .bill-button, .history-button {
            background: #5cb85c;
            position: static;
            width: auto;
            margin-top: 0;
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
        .bill-button:hover {
            background: #4cae4c;
        }
        .history-button {
            background: #f0ad4e;
        }
        .history-button:hover {
            background: #ec971f;
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
    <form action="SellerServlet" method="post" style="margin: 0; padding: 0;">
        <input type="hidden" name="action" value="logout">
        <button type="submit" class="logout-button">Αποσύνδεση</button>
    </form>
    <form action="sellerIndex" style="margin: 0; padding: 0;">
        <button type="submit" class="back-button">Επιστροφή</button>
    </form>
</div>


<div class="container">
    <h1>Πελάτες</h1>

    <c:if test="${not empty param.message}">
        <div class="message">${param.message}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="error">${param.error}</div>
    </c:if>

    <table>
        <tr>
            <th>Κωδικός Πελάτη</th>
            <th>Όνομα</th>
            <th>Επώνυμο</th>
            <th>ΑΦΜ</th>
            <th>Αριθμός Τηλεφώνου</th>
            <th>Πακέτο</th>
            <th>Action</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                conn = DatabaseUtil.getConnection();
                stmt = conn.createStatement();
                String query = "SELECT * FROM clients";
                rs = stmt.executeQuery(query);

                while (rs.next()) {
                    int id = rs.getInt("clientid");
                    String name = rs.getString("clientname");
                    String surname = rs.getString("clientsurname");
                    int afm = rs.getInt("afm");
                    String number = rs.getString("phone_number");
                    int packageid = rs.getInt("package_id");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= surname %></td>
            <td><%= afm %></td>
            <td><%= number %></td>
            <td><%= packageid %></td>
            <td>
                <form action="SellerServlet" method="post" style="margin: 0; padding: 0; display: inline-block;">
                    <input type="hidden" name="action" value="issueBill">
                    <input type="hidden" name="clientId" value="<%= id %>">
                    <button type="submit" class="bill-button">Έκδοση Λογαριασμόυ</button>
                </form>
                <form action="SellerServlet" method="post" style="margin: 0; padding: 0; display: inline-block;">
                    <input type="hidden" name="action" value="viewCallHistory">
                    <input type="hidden" name="clientId" value="<%= id %>">
                    <button type="submit" class="history-button">Ιστορικό Κλήσεων</button>
                </form>
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
</div>
</body>
</html>
