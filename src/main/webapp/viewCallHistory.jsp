
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Call History</title>
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
        h1 {
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
        .back-button {
            padding: 5px 10px;
            background: #5c85d6;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            display: inline-block;
            margin-top: 20px;
        }
        .back-button:hover {
            background: #4a73c3;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Ιστορικό Κλήσεων Πελάτη</h1>

    <form action="sellerIndex" method="get">
        <button type="submit" class="back-button">Επιστροφή</button>
    </form>

    <table>

        ${callHistory}
    </table>
    <form action="viewCustomers.jsp" method="get" style="margin: 0; padding: 0;">
        <button type="submit" class="back-button">Back</button>
    </form>
</div>
</body>
</html>
