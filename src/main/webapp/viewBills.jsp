<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    if (!userRole.equals("client")) {
        response.sendRedirect("login.jsp");
        return;
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Client Bills</title>
    <style>
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
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
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #444;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            color: #444;
        }

        .back-button {
            padding: 10px;
            background: #5bc0de;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            width: 100px;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background: #31b0d5;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Οι λογαριασμοί σας</h1>
    <c:if test="${not empty bills}">
        ${bills}
    </c:if>
    <form action="clientIndex" style="margin: 0; padding: 0;">
        <button type="submit" class="back-button">Επιστροφή</button>
    </form>
</div>
</body>
</html>
