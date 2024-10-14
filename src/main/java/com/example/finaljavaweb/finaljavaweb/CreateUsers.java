package com.example.finaljavaweb.finaljavaweb;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class CreateUsers {
    private static final int ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256;

    private static Integer generateUserId() {
        Integer lastUserId = getLastUserId();
        if (lastUserId != null) {
            return lastUserId + 1;
        } else {
            return 1000;
        }
    }

    private static Integer getLastUserId() {
        try {
            Connection conn = DatabaseUtil.getConnection();
            if (conn != null) {
                String sql = "SELECT MAX(clientId) AS maxId FROM clients";
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int maxId = rs.getInt("maxId");
                    rs.close();
                    stmt.close();
                    conn.close();
                    return maxId;
                } else {
                    rs.close();
                    stmt.close();
                    conn.close();
                    return null;
                }
            } else {
                System.out.println("Database connection failed");
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean createNewClient(String name, String surname, int AFM, String phoneNumber, String userRole) {
        Integer userId = generateUserId();
        try {
            Connection conn = DatabaseUtil.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO clients (clientId, clientName, clientSurname, client_role, afm, phone_number) VALUES (?, ?, ?, ?, ?,?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setString(2, name);
                stmt.setString(3, surname);
                stmt.setString(4, userRole);
                stmt.setInt(5, AFM);
                stmt.setString(6, phoneNumber);
                int rowsInserted = stmt.executeUpdate();
                stmt.close();
                conn.close();
                return rowsInserted > 0;
            } else {
                System.out.println("Database connection failed");
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean registerUser(String username, String password, String role) {
        try {
            byte[] salt = generateSalt();
            String hashedPassword = hashPassword(password, salt);
            String saltHex = byteArrayToHexString(salt);

            Connection conn = DatabaseUtil.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO users (username, password, salt, role) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, hashedPassword);
                stmt.setString(3, saltHex);
                stmt.setString(4, role);

                int rowsInserted = stmt.executeUpdate();
                stmt.close();
                conn.close();
                return rowsInserted > 0;
            } else {
                System.out.println("Database connection failed");
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static byte[] generateSalt() throws NoSuchAlgorithmException {
        return SecureRandom.getInstanceStrong().generateSeed(32);
    }

    private static String hashPassword(String password, byte[] salt) throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        byte[] hash = factory.generateSecret(spec).getEncoded();
        return Base64.getEncoder().encodeToString(hash);
    }

    private static String byteArrayToHexString(byte[] byteArray) {
        StringBuilder sb = new StringBuilder();
        for (byte b : byteArray) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
