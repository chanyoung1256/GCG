//package dao;
//
//import model.User;
//import java.sql.*;
//
//public class UserDAO {
//
//    private Connection getConnection() {
//        try {
//            String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
//            String user = "root";
//            String password = "Gimchanyoung1!";
//            Class.forName("com.mysql.cj.jdbc.Driver");
//            return DriverManager.getConnection(url, user, password);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
//
//    // 사용자 등록
//    public void insertUser(User user) {
//        String sql = "INSERT INTO users (username, password) VALUES (?, ?)";
//        try (Connection conn = getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setString(1, user.getUsername());
//            stmt.setString(2, user.getPassword());
//            stmt.executeUpdate();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    // 로그인 인증
//    public boolean validateUser(String username, String password) {
//        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
//        try (Connection conn = getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setString(1, username);
//            stmt.setString(2, password);
//            try (ResultSet rs = stmt.executeQuery()) {
//                return rs.next();
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    // 유저 ID 조회
//    public User getUserByUsername(String username) {
//        String sql = "SELECT * FROM users WHERE username = ?";
//        try (Connection conn = getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setString(1, username);
//            try (ResultSet rs = stmt.executeQuery()) {
//                if (rs.next()) {
//                    User user = new User();
//                    user.setId(rs.getInt("id"));
//                    user.setUsername(rs.getString("username"));
//                    user.setPassword(rs.getString("password"));
//                    user.setCreatedAt(rs.getTimestamp("created_at"));
//                    return user;
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//}


package dao;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection getConnection() {
        try {
            String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
            String user = "root";
            String password = "Gimchanyoung1!";
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 사용자 등록 
    public boolean insertUser(User user) {
        String sql = "INSERT INTO users (username, password, email, is_admin) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setBoolean(4, user.isAdmin());
            
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 로그인 인증
    public boolean validateUser(String username, String password) {
        String sql = "SELECT id FROM users WHERE username = ? AND password = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByUsername(String username) {
        String sql = "SELECT id, username, password, email, is_admin, created_at FROM users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setAdmin(rs.getBoolean("is_admin"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ID로 사용자 정보 조회
    public User getUserById(int userId) {
        String sql = "SELECT id, username, password, email, is_admin, created_at FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setAdmin(rs.getBoolean("is_admin"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 모든 사용자 목록 조회
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, email, is_admin, created_at FROM users ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setAdmin(rs.getBoolean("is_admin"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    // 사용자 삭제 (관리자 기능)
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 사용자 정보 업데이트
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, is_admin = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setBoolean(3, user.isAdmin());
            stmt.setInt(4, user.getId());
            
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 비밀번호 변경
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 사용자명 중복 체크
    public boolean isUsernameExists(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 이메일 중복 체크
    public boolean isEmailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 전체 사용자 수 조회
    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}


