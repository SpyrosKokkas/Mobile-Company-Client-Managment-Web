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
    <title>Client Dashboard</title>
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
            text-align: center;
        }

        h1, h2 {
            color: #444;
            text-align: center;
        }

        form {
            background: #fff;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="email"],
        button {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 12px;
            border: 1px solid #b6a7a3;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            background: #5c85d6;
            color: #fff;
            cursor: pointer;
            border: none;
            font-size: 16px;
            padding: 10px;
            margin: 0;
            transition: background-color 0.3s;
        }

        button:hover {
            background: #4a73c3;
        }

        .logout-back-container {
            position: absolute;
            top: 15px;
            right: 15px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .logout-button {
            padding: 10px;
            background: #d9534f;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            width: 100px;
            transition: background-color 0.3s;
        }

        .logout-button:hover {
            background: #c9302c;
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

        .small-button {
            width: auto;
            padding: 12px 24px;
        }

        .inline-form {
            display: inline-block;
            padding: 12px;
            margin: 8px;
        }

        .hidden-form {
            display: none;
            margin-top: 20px;
        }

    </style>
    <script>
        function showAFMForm() {
            document.getElementById('afm-form').style.display = 'block';
        }
    </script>
</head>
<body>
<div class="logout-back-container">
    <form action="clientAction" method="post" style="margin: 0; padding: 0;">
        <input type="hidden" name="action" value="logout">
        <button type="submit" class="logout-button">Αποσύνδεση</button>
    </form>
</div>

<div class="container">
    <h1>Πίνακας Πελατών</h1>

    <c:if test="${not empty param.message}">
        <div class="message">${param.message}</div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="error">${param.error}</div>
    </c:if>

    <h2>Ιστορικό Κλήσεων Πελάτη</h2>
    <form action="clientAction" method="post" class="inline-form">
        <input type="hidden" name="action" value="viewCallHistory">
        <button type="submit" class="small-button">Προβολή</button>
    </form>

    <h2>Προβολή Λογαριασμών</h2>
    <form action="clientAction" method="post" class="inline-form">
        <input type="hidden" name="action" value="viewBills">
        <button type="submit" class="small-button">Προβολή</button>
    </form>
</div>
</body>
</html>
