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
    <h1>Διαθέσιμα Πακέτα Τηλεφωνίας</h1>

    <c:if test="${not empty param.message}">
        <div class="message">${param.message}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="error">${param.error}</div>
    </c:if>

    <table>
        <tr>
            <th>Κωδικός</th>
            <th>Όνομα</th>
            <th>Περιγραφή</th>
            <th>Τιμή</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                conn = DatabaseUtil.getConnection();
                stmt = conn.createStatement();
                String query = "SELECT * FROM packages";
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
</div>
</body>
</html>
