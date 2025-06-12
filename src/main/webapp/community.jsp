<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="model.*" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
   
    String action = request.getParameter("action");
    if ("createComment".equals(action) && userId != null) {
        String content = request.getParameter("content");
        String postIdStr = request.getParameter("postId");
        
        if (content != null && postIdStr != null) {
            try {
                String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
                String user = "root";
                String password = "Gimchanyoung1!";
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, user, password);
                
                PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)"
                );
                stmt.setInt(1, Integer.parseInt(postIdStr));
                stmt.setInt(2, userId);
                stmt.setString(3, content);
                stmt.executeUpdate();
                
                conn.close();
                
                response.sendRedirect("community.jsp");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    if ("createPost".equals(action) && userId != null) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        
        if (title != null && content != null) {
            try {
                String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
                String user = "root";
                String password = "Gimchanyoung1!";
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, user, password);
                
                PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO community_posts (user_id, title, content) VALUES (?, ?, ?)"
                );
                stmt.setInt(1, userId);
                stmt.setString(2, title);
                stmt.setString(3, content);
                stmt.executeUpdate();
                
                conn.close();
                
                response.sendRedirect("community.jsp");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    if ("toggleLike".equals(action) && userId != null) {
        String postIdStr = request.getParameter("postId");
        
        if (postIdStr != null) {
            try {
                String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
                String user = "root";
                String password = "Gimchanyoung1!";
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, user, password);
             
                PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT id FROM post_likes WHERE post_id = ? AND user_id = ?"
                );
                checkStmt.setInt(1, Integer.parseInt(postIdStr));
                checkStmt.setInt(2, userId);
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    PreparedStatement deleteStmt = conn.prepareStatement(
                        "DELETE FROM post_likes WHERE post_id = ? AND user_id = ?"
                    );
                    deleteStmt.setInt(1, Integer.parseInt(postIdStr));
                    deleteStmt.setInt(2, userId);
                    deleteStmt.executeUpdate();
                } else {
                    PreparedStatement insertStmt = conn.prepareStatement(
                        "INSERT INTO post_likes (post_id, user_id) VALUES (?, ?)"
                    );
                    insertStmt.setInt(1, Integer.parseInt(postIdStr));
                    insertStmt.setInt(2, userId);
                    insertStmt.executeUpdate();
                }
                
                conn.close();
                
                response.sendRedirect("community.jsp");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    if ("deletePost".equals(action) && userId != null) {
        String postIdStr = request.getParameter("postId");
        
        if (postIdStr != null) {
            try {
                String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
                String user = "root";
                String password = "Gimchanyoung1!";
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, user, password);
                
                PreparedStatement stmt = conn.prepareStatement(
                    "DELETE FROM community_posts WHERE id = ? AND user_id = ?"
                );
                stmt.setInt(1, Integer.parseInt(postIdStr));
                stmt.setInt(2, userId);
                stmt.executeUpdate();
                
                conn.close();
                
                response.sendRedirect("community.jsp");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    if ("deleteComment".equals(action) && userId != null) {
        String commentIdStr = request.getParameter("commentId");
        
        if (commentIdStr != null) {
            try {
                String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
                String user = "root";
                String password = "Gimchanyoung1!";
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, user, password);
                
                PreparedStatement stmt = conn.prepareStatement(
                    "DELETE FROM comments WHERE id = ? AND user_id = ?"
                );
                stmt.setInt(1, Integer.parseInt(commentIdStr));
                stmt.setInt(2, userId);
                stmt.executeUpdate();
                
                conn.close();
                
                response.sendRedirect("community.jsp");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    List<CommunityPost> posts = new ArrayList<>();
    try {
        String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String password = "Gimchanyoung1!";
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, user, password);
        
        String sql = "SELECT cp.*, u.username, " +
                    "(SELECT COUNT(*) FROM post_likes pl WHERE pl.post_id = cp.id) as like_count, " +
                    "(SELECT COUNT(*) FROM comments c WHERE c.post_id = cp.id) as comment_count, " +
                    "(SELECT COUNT(*) FROM post_likes pl WHERE pl.post_id = cp.id AND pl.user_id = ?) as is_liked " +
                    "FROM community_posts cp " +
                    "JOIN users u ON cp.user_id = u.id " +
                    "ORDER BY cp.created_at DESC";
        
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId != null ? userId : 0);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            CommunityPost post = new CommunityPost();
            post.setId(rs.getInt("id"));
            post.setUserId(rs.getInt("user_id"));
            post.setUsername(rs.getString("username"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setCreatedAt(rs.getTimestamp("created_at"));
            post.setLikeCount(rs.getInt("like_count"));
            post.setCommentCount(rs.getInt("comment_count"));
            post.setLiked(rs.getInt("is_liked") > 0);
            posts.add(post);
        }
        
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<%@ include file="header.jsp" %>

<main class="max-w-7xl mx-auto pt-24 pb-16 px-4">
    <div class="flex justify-between items-center mb-10">
        <div>
            <h2 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">커뮤니티</h2>
            <p class="text-gray-600 dark:text-gray-400">사용자들과 소통하고 경험을 공유해보세요</p>
        </div>
        <% if (username != null) { %>
            <button onclick="openCreateModal()" class="px-6 py-3 rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 text-white font-semibold shadow-lg hover:from-purple-700 hover:to-pink-700 hover:shadow-xl transform hover:scale-105 transition-all duration-300">
                ✏️ 새 게시글 작성
            </button>
        <% } else { %>
            <a href="login.jsp" class="px-6 py-3 rounded-xl bg-gray-600 text-white font-semibold shadow-lg hover:bg-gray-700 transition-all duration-300">
                로그인하여 참여하기
            </a>
        <% } %>
    </div>

    <div class="grid gap-6">
        <%
            if (!posts.isEmpty()) {
                for (CommunityPost post : posts) {
        %>
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold">
                        <%= post.getUsername().substring(0, 1).toUpperCase() %>
                    </div>
                    <div>
                        <p class="font-semibold text-gray-900 dark:text-white"><%= post.getUsername() %></p>
                        <p class="text-sm text-gray-500 dark:text-gray-400"><%= post.getCreatedAt() %></p>
                    </div>
                </div>
                <% if (userId != null && userId == post.getUserId()) { %>
                <form action="community.jsp" method="post" class="inline">
                    <input type="hidden" name="action" value="deletePost">
                    <input type="hidden" name="postId" value="<%= post.getId() %>">
                    <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')" class="px-3 py-1 bg-red-100 text-red-700 rounded hover:bg-red-200 transition-colors">
                        삭제
                    </button>
                </form>
                <% } %>
            </div>

            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3"><%= post.getTitle() %></h3>
            <p class="text-gray-700 dark:text-gray-300 mb-4 leading-relaxed"><%= post.getContent() %></p>
            
            <div class="flex items-center gap-4 pt-4 border-t dark:border-gray-700">
                <% if (username != null) { %>
                <form action="community.jsp" method="post" class="inline">
                    <input type="hidden" name="action" value="toggleLike">
                    <input type="hidden" name="postId" value="<%= post.getId() %>">
                    <button type="submit" class="flex items-center gap-2 px-3 py-2 rounded-lg transition-colors <%= post.isLiked() ? "bg-red-100 text-red-600" : "bg-gray-100 text-gray-600 hover:bg-gray-200" %>">
                        <span><%= post.isLiked() ? "❤️" : "🤍" %></span>
                        <span><%= post.getLikeCount() %></span>
                    </button>
                </form>
                <% } else { %>
                <div class="flex items-center gap-2 px-3 py-2 bg-gray-100 text-gray-600 rounded-lg">
                    <span>🤍</span>
                    <span><%= post.getLikeCount() %></span>
                </div>
                <% } %>
                
                <button onclick="toggleComments(<%= post.getId() %>)" class="flex items-center gap-2 px-3 py-2 bg-gray-100 text-gray-600 rounded-lg hover:bg-gray-200 transition-colors">
                    💬 댓글 <span><%= post.getCommentCount() %></span>
                </button>
            </div>

            <div id="comments-<%= post.getId() %>" class="hidden mt-4 pt-4 border-t dark:border-gray-700">
                <% if (username != null) { %>
                <form action="community.jsp" method="post" class="mb-4">
                    <input type="hidden" name="action" value="createComment">
                    <input type="hidden" name="postId" value="<%= post.getId() %>">
                    <div class="flex gap-3">
                        <div class="w-8 h-8 bg-gradient-to-r from-green-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold text-sm">
                            <%= username.substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="flex-1">
                            <textarea name="content" placeholder="댓글을 작성해주세요..." required class="w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white resize-none" rows="2"></textarea>
                            <div class="flex justify-end mt-2">
                                <button type="submit" class="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors">
                                    댓글 작성
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
                <% } %>
                
                <div class="space-y-3">
                    <%
                        try {
                            String url2 = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
                            String user2 = "root";
                            String password2 = "Gimchanyoung1!";
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn2 = DriverManager.getConnection(url2, user2, password2);
                            
                            PreparedStatement stmt2 = conn2.prepareStatement(
                                "SELECT c.*, u.username FROM comments c " +
                                "JOIN users u ON c.user_id = u.id " +
                                "WHERE c.post_id = ? ORDER BY c.created_at ASC"
                            );
                            stmt2.setInt(1, post.getId());
                            ResultSet rs2 = stmt2.executeQuery();
                            
                            boolean hasComments = false;
                            while (rs2.next()) {
                                hasComments = true;
                    %>
                    <div class="flex gap-3 p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
                        <div class="w-8 h-8 bg-gradient-to-r from-green-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold text-sm">
                            <%= rs2.getString("username").substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="flex-1">
                            <div class="flex items-center gap-2 mb-1">
                                <span class="font-semibold text-gray-900 dark:text-white"><%= rs2.getString("username") %></span>
                                <span class="text-sm text-gray-500 dark:text-gray-400"><%= rs2.getTimestamp("created_at") %></span>
                                <% if (userId != null && userId == rs2.getInt("user_id")) { %>
                                <form action="community.jsp" method="post" class="ml-auto">
                                    <input type="hidden" name="action" value="deleteComment">
                                    <input type="hidden" name="commentId" value="<%= rs2.getInt("id") %>">
                                    <button type="submit" onclick="return confirm('댓글을 삭제하시겠습니까?')" class="text-red-500 hover:text-red-700 text-sm">삭제</button>
                                </form>
                                <% } %>
                            </div>
                            <p class="text-gray-700 dark:text-gray-300"><%= rs2.getString("content") %></p>
                        </div>
                    </div>
                    <%
                            }
                            if (!hasComments) {
                    %>
                    <p class="text-gray-500 dark:text-gray-400 text-center py-4">아직 댓글이 없습니다.</p>
                    <%
                            }
                            conn2.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="text-center py-16">
            <div class="text-6xl mb-4">📝</div>
            <h3 class="text-xl font-semibold text-gray-700 dark:text-gray-300 mb-2">아직 게시글이 없습니다</h3>
            <p class="text-gray-500 dark:text-gray-400 mb-4">첫 번째 게시글을 작성해보세요!</p>
            <% if (username != null) { %>
            <button onclick="openCreateModal()" class="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors">
                게시글 작성하기
            </button>
            <% } %>
        </div>
        <%
            }
        %>
    </div>
</main>

<% if (username != null) { %>
<div id="createModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden">
    <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-2xl max-w-2xl w-full" id="createModalContent">
        <div class="flex justify-between items-center p-6 border-b dark:border-gray-700">
            <h2 class="text-2xl font-bold dark:text-white">새 게시글 작성</h2>
            <button onclick="closeCreateModal()" class="text-gray-500 hover:text-gray-700 text-2xl">✕</button>
        </div>
        
        <form action="community.jsp" method="post" class="p-6">
            <input type="hidden" name="action" value="createPost">
            
            <div class="mb-6">
                <label class="block text-lg font-semibold mb-2 dark:text-white">제목</label>
                <input type="text" name="title" required maxlength="255" placeholder="게시글 제목을 입력하세요"
                       class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 bg-white dark:bg-gray-700 text-black dark:text-white">
            </div>
            
            <div class="mb-6">
                <label class="block text-lg font-semibold mb-2 dark:text-white">내용</label>
                <textarea name="content" rows="8" required placeholder="내용을 입력하세요"
                          class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 bg-white dark:bg-gray-700 text-black dark:text-white resize-none"></textarea>
            </div>
            
            <div class="flex justify-end gap-3">
                <button type="button" onclick="closeCreateModal()" class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300">취소</button>
                <button type="submit" class="px-6 py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-lg hover:from-purple-700 hover:to-pink-700">게시글 작성</button>
            </div>
        </form>
    </div>
</div>
<% } %>

<%@ include file="footer.jsp" %>

<script>
	function openCreateModal() {
	    document.getElementById('createModal').classList.remove('hidden');
	    document.body.style.overflow = 'hidden';
	}
	
	function closeCreateModal() {
	    document.getElementById('createModal').classList.add('hidden');
	    document.body.style.overflow = 'auto';
	}
	
	function toggleComments(postId) {
	    const commentsDiv = document.getElementById('comments-' + postId);
	    commentsDiv.classList.toggle('hidden');
	}
	
	document.addEventListener('click', function(event) {
	    const modal = document.getElementById('createModal');
	    if (event.target === modal) {
	        closeCreateModal();
	    }
	});
</script>



