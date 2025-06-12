package servlet;

import dao.BoardDAO;
import model.Post;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/writePost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB
    maxFileSize = 50 * 1024 * 1024,       // 50MB
    maxRequestSize = 100 * 1024 * 1024    // 100MB
)
public class BoardWriteServlet extends HttpServlet {
    
    // 이미지 확장자
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    private static final String[] ALLOWED_MIME_TYPES = {
        "image/jpeg", "image/png", "image/gif", "image/webp"
    };
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        try {
            if (!isUserLoggedIn(request, response)) {
                return;
            }
            
            Map<String, String> formData = validateAndExtractFormData(request);
            String imagePath = handleFileUpload(request);
            
            savePost(request, formData, imagePath);
            response.sendRedirect(request.getContextPath() + "/list.jsp?success=true");
            
        } catch (Exception e) {
            handleError(request, response, e);
        }
    }
    
    private boolean isUserLoggedIn(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.sendRedirect("login.jsp?error=login_required");
            return false;
        }
        return true;
    }
    
    private Map<String, String> validateAndExtractFormData(HttpServletRequest request) 
            throws ServletException {
        Map<String, String> formData = new HashMap<>();
        
        String title = request.getParameter("title");
        String address = request.getParameter("address");
        String content = request.getParameter("content");
        
        if (title == null || title.trim().isEmpty()) {
            throw new ServletException("제목을 입력해주세요.");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new ServletException("내용을 입력해주세요.");
        }
        
        if (title.length() > 100) {
            throw new ServletException("제목은 100자 이하로 입력해주세요.");
        }
        if (content.length() > 2000) {
            throw new ServletException("내용은 2000자 이하로 입력해주세요.");
        }
        
        formData.put("title", sanitizeInput(title.trim()));
        formData.put("content", sanitizeInput(content.trim()));
        formData.put("address", address != null ? sanitizeInput(address.trim()) : "");
        
        return formData;
    }
    
    private String handleFileUpload(HttpServletRequest request) 
            throws ServletException, IOException {
        Part filePart = request.getPart("photo");
        
        if (filePart == null || filePart.getSize() == 0) {
            throw new ServletException("이미지 파일을 선택해주세요.");
        }
        
        validateFile(filePart);
        
        String safeFileName = generateSafeFileName(filePart);
        
        String uploadPath = getUploadPath(request);
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            throw new ServletException("업로드 디렉토리 생성에 실패했습니다.");
        }
        
        File uploadedFile = new File(uploadDir, safeFileName);
        filePart.write(uploadedFile.getAbsolutePath());
        
        return "uploads/" + safeFileName;
    }
    
    private void validateFile(Part filePart) throws ServletException {
        String originalFileName = filePart.getSubmittedFileName();
        String contentType = filePart.getContentType();
        
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            throw new ServletException("유효하지 않은 파일명입니다.");
        }
        
        String fileExtension = getFileExtension(originalFileName).toLowerCase();
        if (!Arrays.asList(ALLOWED_EXTENSIONS).contains(fileExtension)) {
            throw new ServletException("허용되지 않는 파일 형식입니다. (jpg, jpeg, png, gif, webp만 가능)");
        }
        
        if (contentType == null || !Arrays.asList(ALLOWED_MIME_TYPES).contains(contentType)) {
            throw new ServletException("유효하지 않은 이미지 파일입니다.");
        }
        
        if (filePart.getSize() > 5 * 1024 * 1024) {
            throw new ServletException("파일 크기는 5MB 이하여야 합니다.");
        }
    }
    
    private String generateSafeFileName(Part filePart) {
        String originalFileName = filePart.getSubmittedFileName();
        String fileExtension = getFileExtension(originalFileName);
      
        String timestamp = String.valueOf(System.currentTimeMillis());
        String uuid = UUID.randomUUID().toString().substring(0, 8);
        
        return timestamp + "_" + uuid + fileExtension;
    }
    
    private String getFileExtension(String fileName) {
        int dotIndex = fileName.lastIndexOf(".");
        return dotIndex > 0 ? fileName.substring(dotIndex) : "";
    }
    
    private String getUploadPath(HttpServletRequest request) {
        String webAppPath = getServletContext().getRealPath("/");
        return webAppPath + "uploads";
    }
    
    private void savePost(HttpServletRequest request, Map<String, String> formData, String imagePath) 
            throws ServletException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            throw new ServletException("사용자 인증 정보가 없습니다.");
        }
        
        try {
            Post post = new Post();
            post.setUserId(userId);
            post.setTitle(formData.get("title"));
            post.setContent(formData.get("content"));
            post.setAddress(formData.get("address"));
            post.setImagePath(imagePath);
            
            BoardDAO dao = new BoardDAO();
            dao.insertPost(post);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("게시글 저장 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }
  
    private String sanitizeInput(String input) {
        if (input == null) return "";
        return input.replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;")
                   .replaceAll("/", "&#x2F;");
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("errorMessage", e.getMessage());
        request.getRequestDispatcher("/write.jsp").forward(request, response);
    }
}
