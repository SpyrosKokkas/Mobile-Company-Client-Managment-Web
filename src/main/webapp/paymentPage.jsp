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
    <title>Payment Page</title>
    <style>
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 50%;
            margin: 0 auto;
            padding: 25px;
            position: relative;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #444;
            text-align: center;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-top: 10px;
        }

        input[type="text"], input[type="number"], input[type="date"] {
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .submit-button {
            padding: 10px;
            background: #5bc0de;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 20px;
            width: 100px;
            transition: background-color 0.3s;
        }

        .submit-button:hover {
            background: #31b0d5;
        }

        .error {
            color: red;
            margin-top: 10px;
        }

        .message {
            color: green;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Payment Page</h1>
    <c:if test="${not empty param.error}">
        <div class="error">${param.error}</div>
    </c:if>
    <c:if test="${not empty param.message}">
        <div class="message">${param.message}</div>
    </c:if>
    <form action="clientAction?action=payBill" method="post">
        <input type="hidden" name="billId" value="${param.billId}">
        <label for="cardNumber">Card Number:</label>
        <input type="text" id="cardNumber" name="cardNumber" required>
        <label for="expiryDate">Expiry Date:</label>
        <input type="date" id="expiryDate" name="expiryDate" required>
        <label for="cvv">CVV:</label>
        <input type="number" id="cvv" name="cvv" required>
        <button type="submit" class="submit-button">Pay</button>
    </form>
</div>
</body>
</html>
