package dao;

import model.CommunityPost;
import model.Comment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommunityDAO {
    
    // DB
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

    public List<CommunityPost> getAllPosts(int currentUserId) {
        List<CommunityPost> posts = new ArrayList<>();
        String sql = "SELECT cp.*, u.username, " +
                    "(SELECT COUNT(*) FROM post_likes pl WHERE pl.post_id = cp.id) as like_count, " +
                    "(SELECT COUNT(*) FROM comments c WHERE c.post_id = cp.id) as comment_count, " +
                    "(SELECT COUNT(*) FROM post_likes pl WHERE pl.post_id = cp.id AND pl.user_id = ?) as is_liked " +
                    "FROM community_posts cp " +
                    "JOIN users u ON cp.user_id = u.id " +
                    "ORDER BY cp.created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, currentUserId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                CommunityPost post = new CommunityPost();
                post.setId(rs.getInt("id"));
                post.setUserId(rs.getInt("user_id"));
                post.setUsername(rs.getString("username"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setImagePath(rs.getString("image_path"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setLikeCount(rs.getInt("like_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                post.setLiked(rs.getInt("is_liked") > 0);
                posts.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }

    // 게시글 생성
    public boolean createPost(CommunityPost post) {
        String sql = "INSERT INTO community_posts (user_id, title, content, image_path) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, post.getUserId());
            stmt.setString(2, post.getTitle());
            stmt.setString(3, post.getContent());
            stmt.setString(4, post.getImagePath());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 댓글 조회
    public List<Comment> getCommentsByPostId(int postId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.username FROM comments c " +
                    "JOIN users u ON c.user_id = u.id " +
                    "WHERE c.post_id = ? ORDER BY c.created_at ASC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setPostId(rs.getInt("post_id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setUsername(rs.getString("username"));
                comment.setContent(rs.getString("content"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
                comments.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return comments;
    }

    // 댓글 생성
    public boolean createComment(Comment comment) {
        String sql = "INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, comment.getPostId());
            stmt.setInt(2, comment.getUserId());
            stmt.setString(3, comment.getContent());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 좋아요
    public boolean toggleLike(int postId, int userId) {
        try (Connection conn = getConnection()) {
            // 기존 좋아요 확인
            String checkSql = "SELECT id FROM post_likes WHERE post_id = ? AND user_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, postId);
            checkStmt.setInt(2, userId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // 좋아요 제거
                String deleteSql = "DELETE FROM post_likes WHERE post_id = ? AND user_id = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setInt(1, postId);
                deleteStmt.setInt(2, userId);
                return deleteStmt.executeUpdate() > 0;
            } else {
                // 좋아요 추가
                String insertSql = "INSERT INTO post_likes (post_id, user_id) VALUES (?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, postId);
                insertStmt.setInt(2, userId);
                return insertStmt.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 제 
    public boolean deletePost(int postId, int userId) {
        String sql = "DELETE FROM community_posts WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 댓글 삭제
    public boolean deleteComment(int commentId, int userId) {
        String sql = "DELETE FROM comments WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, commentId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
