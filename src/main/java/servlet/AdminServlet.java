package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import model.Post;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    
    // DB 연결
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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        
        // 관리자 권한 체크
        if (!"admin".equals(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "dashboard";
        
        switch (action) {
            case "users":
                loadUsers(request, response);
                break;
            case "posts":
                loadPosts(request, response);
                break;
            case "delete_user":
                deleteUser(request, response);
                return;
            case "delete_post":
                deletePost(request, response);
                return;
            default:
                loadDashboard(request, response);
                break;
        }
        
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        
        if (!"admin".equals(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "edit_post":
                editPost(request, response);
                break;
            case "edit_user":
                editUser(request, response);
                break;
            default:
                response.sendRedirect("admin");
                break;
        }
    }
    
    private void loadDashboard(HttpServletRequest request, HttpServletResponse response) {
        try (Connection conn = getConnection()) {
            // 사용자 수
            PreparedStatement userStmt = conn.prepareStatement("SELECT COUNT(*) FROM users");
            ResultSet userRs = userStmt.executeQuery();
            int userCount = 0;
            if (userRs.next()) {
                userCount = userRs.getInt(1);
            }
            
            // 게시글 수
            PreparedStatement postStmt = conn.prepareStatement("SELECT COUNT(*) FROM posts");
            ResultSet postRs = postStmt.executeQuery();
            int postCount = 0;
            if (postRs.next()) {
                postCount = postRs.getInt(1);
            }
            
            // 관리자 수
            PreparedStatement adminStmt = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE is_admin = true");
            ResultSet adminRs = adminStmt.executeQuery();
            int adminCount = 0;
            if (adminRs.next()) {
                adminCount = adminRs.getInt(1);
            }
            
            request.setAttribute("userCount", userCount);
            request.setAttribute("postCount", postCount);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("currentView", "dashboard");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void loadUsers(HttpServletRequest request, HttpServletResponse response) {
        List<User> users = new ArrayList<>();
        try (Connection conn = getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT id, username, email, is_admin FROM users ORDER BY id DESC"); 
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username")); 
                user.setEmail(rs.getString("email"));
                user.setAdmin(rs.getBoolean("is_admin"));
                users.add(user);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("users", users);
        request.setAttribute("currentView", "users");
    }
    
    private void loadPosts(HttpServletRequest request, HttpServletResponse response) {
        List<Post> posts = new ArrayList<>();
        try (Connection conn = getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT p.id, p.title, p.content, p.image_path, p.address " +
                "FROM posts p ORDER BY p.id DESC");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setImagePath(rs.getString("image_path"));
                post.setAddress(rs.getString("address"));
                posts.add(post);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("posts", posts);
        request.setAttribute("currentView", "posts");
    }
    
    private void editPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            
            int postId = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String address = request.getParameter("address");
            String imagePath = request.getParameter("image_path"); 
            
            if (title == null || title.trim().isEmpty() ||
                content == null || content.trim().isEmpty()) {
                response.sendRedirect("admin?action=posts&error=empty");
                return;
            }
            
            try (Connection conn = getConnection()) {
                PreparedStatement stmt = conn.prepareStatement(
                    "UPDATE posts SET title = ?, content = ?, address = ?, image_path = ? WHERE id = ?");
                stmt.setString(1, title.trim());
                stmt.setString(2, content.trim());
                stmt.setString(3, address != null ? address.trim() : null);
                stmt.setString(4, imagePath != null ? imagePath.trim() : null); 
                stmt.setInt(5, postId);
                
                int result = stmt.executeUpdate();
                
                if (result > 0) {
                    response.sendRedirect("admin?action=posts&success=edit");
                } else {
                    response.sendRedirect("admin?action=posts&error=notfound");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?action=posts&error=server");
        }
    }

    
    private void editUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            
            int userId = Integer.parseInt(request.getParameter("id"));
            boolean isAdmin = "true".equals(request.getParameter("is_admin"));
            
            try (Connection conn = getConnection()) {
                PreparedStatement stmt = conn.prepareStatement(
                    "UPDATE users SET is_admin = ? WHERE id = ?");
                stmt.setBoolean(1, isAdmin);
                stmt.setInt(2, userId);
                
                int result = stmt.executeUpdate();
                
                if (result > 0) {
                    response.sendRedirect("admin?action=users&success=edit");
                } else {
                    response.sendRedirect("admin?action=users&error=notfound");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?action=users&error=server");
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            
            HttpSession session = request.getSession();
            Integer currentUserId = (Integer) session.getAttribute("user_id");
            
            if (currentUserId != null && currentUserId == userId) {
                response.sendRedirect("admin?action=users&error=self_delete");
                return;
            }
            
            try (Connection conn = getConnection()) {
                conn.setAutoCommit(false);
                
                try {
                    PreparedStatement deletePostsStmt = conn.prepareStatement(
                        "DELETE FROM posts WHERE user_id = ?");
                    deletePostsStmt.setInt(1, userId);
                    deletePostsStmt.executeUpdate();
                    
                    PreparedStatement deleteUserStmt = conn.prepareStatement(
                        "DELETE FROM users WHERE id = ?");
                    deleteUserStmt.setInt(1, userId);
                    int result = deleteUserStmt.executeUpdate();
                    
                    if (result > 0) {
                        conn.commit();
                        response.sendRedirect("admin?action=users&success=delete");
                    } else {
                        conn.rollback();
                        response.sendRedirect("admin?action=users&error=notfound");
                    }
                    
                } catch (Exception e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?action=users&error=server");
        }
    }
    
    private void deletePost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            
            try (Connection conn = getConnection()) {
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM posts WHERE id = ?");
                stmt.setInt(1, postId);
                int result = stmt.executeUpdate();
                
                if (result > 0) {
                    response.sendRedirect("admin?action=posts&success=delete");
                } else {
                    response.sendRedirect("admin?action=posts&error=notfound");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?action=posts&error=server");
        }
    }
}

