package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

import model.Post;

public class BoardDAO {

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

    // 게시글 등록
    public void insertPost(Post post) {
        String sql = "INSERT INTO posts (user_id, title, content, address, image_path, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, post.getUserId());
            stmt.setString(2, post.getTitle());
            stmt.setString(3, post.getContent());
            stmt.setString(4, post.getAddress());
            stmt.setString(5, post.getImagePath());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("게시글 저장 실패: " + e.getMessage(), e);
        }
    }

    public List<Post> getAllPosts() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM posts ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setAddress(rs.getString("address"));
                post.setImagePath(rs.getString("image_path"));
                
                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    post.setCreatedAt(timestamp.toString());
                }
                
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("게시글 목록 조회 실패: " + e.getMessage(), e);
        }
        return list;
    }

    public Post getPostById(int id) {
        Post post = null;
        String sql = "SELECT * FROM posts WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                post = new Post();
                post.setId(rs.getInt("id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setAddress(rs.getString("address"));
                post.setImagePath(rs.getString("image_path"));
                
                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    post.setCreatedAt(timestamp.toString());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("게시글 조회 실패: " + e.getMessage(), e);
        }
        return post;
    }

    public void updatePost(Post post) {
        String sql = "UPDATE posts SET title = ?, content = ?, address = ?, image_path = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setString(3, post.getAddress());
            stmt.setString(4, post.getImagePath());
            stmt.setInt(5, post.getId());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("게시글 수정 실패: " + e.getMessage(), e);
        }
    }
    
    public void deletePost(int id) {
        String sql = "DELETE FROM posts WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("게시글 삭제 실패: " + e.getMessage(), e);
        }
    }
    
    public List<Post> getPostsByUserId(int userId) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM posts WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setAddress(rs.getString("address"));
                post.setImagePath(rs.getString("image_path"));
                
                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    post.setCreatedAt(timestamp.toString());
                }
                
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("사용자 게시글 조회 실패: " + e.getMessage(), e);
        }
        return list;
    }
}
