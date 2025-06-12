package servlet;

import dao.CommunityDAO;
import model.CommunityPost;
import model.Comment;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/community")
public class CommunityServlet extends HttpServlet {
    
    private CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            userId = 0; 
        }
        
        String action = request.getParameter("action");
        
        if ("getComments".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            List<Comment> comments = communityDAO.getCommentsByPostId(postId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < comments.size(); i++) {
                Comment comment = comments.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"id\":").append(comment.getId()).append(",");
                json.append("\"username\":\"").append(comment.getUsername()).append("\",");
                json.append("\"content\":\"").append(comment.getContent().replace("\"", "\\\"")).append("\",");
                json.append("\"userId\":").append(comment.getUserId()).append(",");
                json.append("\"createdAt\":\"").append(comment.getCreatedAt()).append("\"");
                json.append("}");
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
            return;
        }
        
        List<CommunityPost> posts = communityDAO.getAllPosts(userId);
        request.setAttribute("posts", posts);
        request.getRequestDispatcher("community.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "createPost":
                createPost(request, response, userId);
                break;
            case "createComment":
                createComment(request, response, userId);
                break;
            case "toggleLike":
                toggleLike(request, response, userId);
                break;
            case "deletePost":
                deletePost(request, response, userId);
                break;
            case "deleteComment":
                deleteComment(request, response, userId);
                break;
            default:
                response.sendRedirect("community");
                break;
        }
    }

    private void createPost(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String imagePath = request.getParameter("imagePath");
        
        CommunityPost post = new CommunityPost();
        post.setUserId(userId);
        post.setTitle(title);
        post.setContent(content);
        post.setImagePath(imagePath);
        
        communityDAO.createPost(post);
        response.sendRedirect("community");
    }

    private void createComment(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        int postId = Integer.parseInt(request.getParameter("postId"));
        String content = request.getParameter("content");
        
        Comment comment = new Comment();
        comment.setPostId(postId);
        comment.setUserId(userId);
        comment.setContent(content);
        
        boolean success = communityDAO.createComment(comment);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + "}");
    }

    private void toggleLike(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        int postId = Integer.parseInt(request.getParameter("postId"));
        boolean success = communityDAO.toggleLike(postId, userId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + "}");
    }

    private void deletePost(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        int postId = Integer.parseInt(request.getParameter("postId"));
        communityDAO.deletePost(postId, userId);
        response.sendRedirect("community");
    }

    private void deleteComment(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        boolean success = communityDAO.deleteComment(commentId, userId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + "}");
    }
}
