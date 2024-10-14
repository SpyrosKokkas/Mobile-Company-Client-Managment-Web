<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Seller Dashboard</title>
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

        form {
            background: #fff;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            display: inline-block;
        }

        label {
            display: block;
            margin-bottom: 8px;
        }

        input[type="text"],
        input[type="email"],
        button {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            background: #5c85d6;
            color: #fff;
            cursor: pointer;
            border: none;
            font-size: 16px;
            padding: 5px 10px;
            margin: 0;
        }

        button:hover {
            background: #4a73c3;
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
            padding: 10px 20px;
        }

        .inline-form {
            display: inline-block;
            padding: 10px;
            margin: 5px;
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
    <h1>Πίνακας Πωλητών</h1>


    <c:if test="${not empty param.message}">
        <div class="message">${param.message}</div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="error">${param.error}</div>
    </c:if>


    <h2>Διαθέσιμα Πακέτα Τηλεφωνίας</h2>
    <form action="SellerServlet" method="get" class="inline-form">
        <input type="hidden" name="action" value="viewPackages">
        <button type="submit" class="small-button">Προβολή</button>
    </form>
    <h2>Προβολή Πελατών</h2>
    <form action="SellerServlet" method="get" class="inline-form">
        <input type="hidden" name="action" value="viewCustomers">
        <button type="submit" class="small-button">Προβολή</button>
    </form>

    <h2>Προσθήκη νέου πελάτη</h2>
    <form action="SellerServlet" method="post">
        <label for="customerName">Όνομα:</label>
        <input type="text" id="customerName" name="customerName" required><br>
        <label for="surname">Επίθετο:</label>
        <input type="text" id="surname" name="surname" required><br>
        <label for="customerPhone">Τηλέφωνο</label>
        <input type="text" id="customerPhone" name="customerPhone" required><br>
        <label for="AFM">ΑΦΜ:</label>
        <input type="text" id="AFM" name="AFM" required><br>
        <input type="hidden" name="action" value="insertCustomer">
        <button type="submit" class="small-button">Προσθήκη Πελάτη</button>
    </form>

    <h2>Εγγραφή πελάτη σε πακέτο τηλεφωνίας</h2>
    <form action="SellerServlet" method="post">
        <input type="hidden" name="action" value="assignPackage">
        <label for="clientId">Αριθμός Πελάτη</label>
        <input type="text" id="clientId" name="clientId" required><br>
        <label for="packageId">Αριθμός Πακέτου</label>
        <input type="text" id="packageId" name="packageId" required><br>
        <button type="submit" class="small-button">Εγγραφή</button>
    </form>
</div>


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

</body>
</html>
