<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="model.*" %>
<%@ page import="dao.NoticeDAO" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String currentView = request.getParameter("view");
    if (currentView == null) currentView = "dashboard";
    
    String action = request.getParameter("action");
    String message = "";
    String messageType = "";
    
    String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
    String user = "root";
    String password = "Gimchanyoung1!";

    if (action != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            if ("deletePost".equals(action)) {
                String postId = request.getParameter("id");
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM posts WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(postId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "게시글이 삭제되었습니다";
                    messageType = "success";
                } else {
                    message = "게시글 삭제에 실패했습니다";
                    messageType = "error";
                }
            } else if ("editPost".equals(action)) {
                String postId = request.getParameter("postId");
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String address = request.getParameter("address");
                PreparedStatement stmt = conn.prepareStatement("UPDATE posts SET title = ?, content = ?, address = ? WHERE id = ?");
                stmt.setString(1, title);
                stmt.setString(2, content);
                stmt.setString(3, address);
                stmt.setInt(4, Integer.parseInt(postId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "게시글이 수정되었습니다";
                    messageType = "success";
                } else {
                    message = "게시글 수정에 실패했습니다";
                    messageType = "error";
                }
            } else if ("deleteComment".equals(action)) {
                String commentId = request.getParameter("id");
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM comments WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(commentId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "댓글이 삭제되었습니다";
                    messageType = "success";
                } else {
                    message = "댓글 삭제에 실패했습니다";
                    messageType = "error";
                }
            } else if ("updateComment".equals(action)) {
                String commentId = request.getParameter("commentId");
                String content = request.getParameter("content");
                PreparedStatement stmt = conn.prepareStatement("UPDATE comments SET content = ? WHERE id = ?");
                stmt.setString(1, content);
                stmt.setInt(2, Integer.parseInt(commentId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "댓글이 수정되었습니다";
                    messageType = "success";
                } else {
                    message = "댓글 수정에 실패했습니다";
                    messageType = "error";
                }
            } else if ("deleteCommunityPost".equals(action)) {
                String postId = request.getParameter("id");
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM community_posts WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(postId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "커뮤니티 게시글이 삭제되었습니다";
                    messageType = "success";
                } else {
                    message = "게시글 삭제에 실패했습니다";
                    messageType = "error";
                }
            } else if ("edit_user".equals(action)) {
                String userId = request.getParameter("id");
                String isAdmin = request.getParameter("is_admin");
                PreparedStatement stmt = conn.prepareStatement("UPDATE users SET is_admin = ? WHERE id = ?");
                stmt.setBoolean(1, Boolean.parseBoolean(isAdmin));
                stmt.setInt(2, Integer.parseInt(userId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "사용자 권한이 변경되었습니다";
                    messageType = "success";
                } else {
                    message = "권한 변경에 실패했습니다";
                    messageType = "error";
                }
            } else if ("delete_user".equals(action)) {
                String userId = request.getParameter("id");
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(userId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "사용자가 삭제되었습니다";
                    messageType = "success";
                } else {
                    message = "사용자 삭제에 실패했습니다";
                    messageType = "error";
                }
            } else if ("crawlNotices".equals(action)) {
                NoticeDAO noticeDAO = new NoticeDAO();
                List<Notice> newNotices = noticeDAO.crawlAndSaveAllNotices();
                message = "공지사항 크롤링 완료: " + newNotices.size() + "개 공지사항을 저장했습니다";
                messageType = "success";
            } else if ("deleteNotice".equals(action)) {
                String noticeId = request.getParameter("id");
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM notices WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(noticeId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "공지사항이 삭제되었습니다";
                    messageType = "success";
                } else {
                    message = "공지사항 삭제에 실패했습니다";
                    messageType = "error";
                }
            } else if ("editNotice".equals(action)) {
                String noticeId = request.getParameter("noticeId");
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String noticeUrl = request.getParameter("url");
                String source = request.getParameter("source");
                PreparedStatement stmt = conn.prepareStatement("UPDATE notices SET title = ?, content = ?, url = ?, source = ? WHERE id = ?");
                stmt.setString(1, title);
                stmt.setString(2, content);
                stmt.setString(3, noticeUrl);
                stmt.setString(4, source);
                stmt.setInt(5, Integer.parseInt(noticeId));
                int result = stmt.executeUpdate();
                if (result > 0) {
                    message = "공지사항이 수정되었습니다";
                    messageType = "success";
                } else {
                    message = "공지사항 수정에 실패했습니다";
                    messageType = "error";
                }
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "처리 중 오류가 발생했습니다: " + e.getMessage();
            messageType = "error";
        }
    }

    int userCount = 0, postCount = 0, adminCount = 0, communityPostCount = 0, commentCount = 0, noticeCount = 0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, user, password);
        
        PreparedStatement stmt1 = conn.prepareStatement("SELECT COUNT(*) FROM users");
        ResultSet rs1 = stmt1.executeQuery();
        if (rs1.next()) userCount = rs1.getInt(1);
        
        PreparedStatement stmt2 = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE is_admin = 1");
        ResultSet rs2 = stmt2.executeQuery();
        if (rs2.next()) adminCount = rs2.getInt(1);
        
        PreparedStatement stmt3 = conn.prepareStatement("SELECT COUNT(*) FROM posts");
        ResultSet rs3 = stmt3.executeQuery();
        if (rs3.next()) postCount = rs3.getInt(1);
        
        PreparedStatement stmt4 = conn.prepareStatement("SELECT COUNT(*) FROM community_posts");
        ResultSet rs4 = stmt4.executeQuery();
        if (rs4.next()) communityPostCount = rs4.getInt(1);
        
        PreparedStatement stmt5 = conn.prepareStatement("SELECT COUNT(*) FROM comments");
        ResultSet rs5 = stmt5.executeQuery();
        if (rs5.next()) commentCount = rs5.getInt(1);
        
        PreparedStatement stmt6 = conn.prepareStatement("SELECT COUNT(*) FROM notices");
        ResultSet rs6 = stmt6.executeQuery();
        if (rs6.next()) noticeCount = rs6.getInt(1);
        
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<%@ include file="header.jsp" %>

<div class="min-h-screen flex pt-20">
    <!-- 사이드 -->
    <div class="w-64 bg-white dark:bg-gray-800 shadow-lg border-r dark:border-gray-700 fixed h-full top-20 transition-colors duration-300">
        <div class="p-6 border-b dark:border-gray-700">
            <h1 class="text-2xl font-bold text-gray-800 dark:text-white">관리자 패널</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">시스템 관리</p>
        </div>
        <nav class="mt-6">
            <a href="admin.jsp?view=dashboard" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-blue-50 dark:hover:bg-gray-700 transition-colors duration-200 <%= "dashboard".equals(currentView) ? "bg-blue-50 dark:bg-gray-700 border-r-4 border-blue-500" : "" %>">
                <span class="text-xl mr-3">📊</span>
                <span class="font-medium">대시보드</span>
            </a>
            <a href="admin.jsp?view=users" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-blue-50 dark:hover:bg-gray-700 transition-colors duration-200 <%= "users".equals(currentView) ? "bg-blue-50 dark:bg-gray-700 border-r-4 border-blue-500" : "" %>">
                <span class="text-xl mr-3">👥</span>
                <span class="font-medium">사용자 관리</span>
            </a>
            <a href="admin.jsp?view=posts" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-blue-50 dark:hover:bg-gray-700 transition-colors duration-200 <%= "posts".equals(currentView) ? "bg-blue-50 dark:bg-gray-700 border-r-4 border-blue-500" : "" %>">
                <span class="text-xl mr-3">📝</span>
                <span class="font-medium">게시판 관리</span>
            </a>
            <a href="admin.jsp?view=community" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-blue-50 dark:hover:bg-gray-700 transition-colors duration-200 <%= "community".equals(currentView) ? "bg-blue-50 dark:bg-gray-700 border-r-4 border-blue-500" : "" %>">
                <span class="text-xl mr-3">💬</span>
                <span class="font-medium">커뮤니티 관리</span>
            </a>
            <a href="admin.jsp?view=comments" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-blue-50 dark:hover:bg-gray-700 transition-colors duration-200 <%= "comments".equals(currentView) ? "bg-blue-50 dark:bg-gray-700 border-r-4 border-blue-500" : "" %>">
                <span class="text-xl mr-3">💭</span>
                <span class="font-medium">댓글 관리</span>
            </a>
            <a href="admin.jsp?view=notices" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-blue-50 dark:hover:bg-gray-700 transition-colors duration-200 <%= "notices".equals(currentView) ? "bg-blue-50 dark:bg-gray-700 border-r-4 border-blue-500" : "" %>">
                <span class="text-xl mr-3">📢</span>
                <span class="font-medium">공지사항 관리</span>
            </a>
            <div class="border-t dark:border-gray-700 mt-4 pt-4">
                <a href="list.jsp" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-green-50 dark:hover:bg-gray-700 transition-colors duration-200">
                    <span class="text-xl mr-3">🏠</span>
                    <span class="font-medium">메인으로</span>
                </a>
                <a href="community.jsp" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-purple-50 dark:hover:bg-gray-700 transition-colors duration-200">
                    <span class="text-xl mr-3">🌐</span>
                    <span class="font-medium">커뮤니티 보기</span>
                </a>
                <a href="logout" class="flex items-center px-6 py-4 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-gray-700 transition-colors duration-200">
                    <span class="text-xl mr-3">🚪</span>
                    <span class="font-medium">로그아웃</span>
                </a>
            </div>
        </nav>
    </div>
    
    <!-- 메인 -->
    <div class="flex-1 ml-64 p-8">
        <% if (!message.isEmpty()) { %>
        <div class="mb-6 p-4 rounded-lg <%= "error".equals(messageType) ? "bg-red-50 border border-red-200 text-red-700 dark:bg-red-900/20 dark:border-red-800 dark:text-red-400" : "bg-green-50 border border-green-200 text-green-700 dark:bg-green-900/20 dark:border-green-800 dark:text-green-400" %>">
            <div class="flex items-center">
                <span class="text-xl mr-2"><%= "error".equals(messageType) ? "⚠️" : "✅" %></span>
                <span><%= message %></span>
            </div>
        </div>
        <% } %>

        <% if ("dashboard".equals(currentView)) { %>
            <!-- 대시보드 -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">관리자 대시보드</h2>
                <p class="text-gray-600 dark:text-gray-400">시스템 현황을 한눈에 확인하세요</p>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-6 mb-8">
                <div class="bg-white dark:bg-gray-800 p-6 rounded-2xl shadow-lg border-l-4 border-blue-500 transform hover:scale-105 transition-transform duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-700 dark:text-gray-300 mb-2">전체 사용자</h3>
                            <p class="text-3xl font-bold text-blue-600 dark:text-blue-400"><%= userCount %></p>
                        </div>
                        <div class="text-4xl text-blue-500">👥</div>
                    </div>
                </div>
                
                <div class="bg-white dark:bg-gray-800 p-6 rounded-2xl shadow-lg border-l-4 border-green-500 transform hover:scale-105 transition-transform duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-700 dark:text-gray-300 mb-2">게시판 글</h3>
                            <p class="text-3xl font-bold text-green-600 dark:text-green-400"><%= postCount %></p>
                        </div>
                        <div class="text-4xl text-green-500">📝</div>
                    </div>
                </div>
                
                <div class="bg-white dark:bg-gray-800 p-6 rounded-2xl shadow-lg border-l-4 border-purple-500 transform hover:scale-105 transition-transform duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-700 dark:text-gray-300 mb-2">커뮤니티 글</h3>
                            <p class="text-3xl font-bold text-purple-600 dark:text-purple-400"><%= communityPostCount %></p>
                        </div>
                        <div class="text-4xl text-purple-500">💬</div>
                    </div>
                </div>
                
                <div class="bg-white dark:bg-gray-800 p-6 rounded-2xl shadow-lg border-l-4 border-orange-500 transform hover:scale-105 transition-transform duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-700 dark:text-gray-300 mb-2">전체 댓글</h3>
                            <p class="text-3xl font-bold text-orange-600 dark:text-orange-400"><%= commentCount %></p>
                        </div>
                        <div class="text-4xl text-orange-500">💭</div>
                    </div>
                </div>
                
                <div class="bg-white dark:bg-gray-800 p-6 rounded-2xl shadow-lg border-l-4 border-pink-500 transform hover:scale-105 transition-transform duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-700 dark:text-gray-300 mb-2">공지사항</h3>
                            <p class="text-3xl font-bold text-pink-600 dark:text-pink-400"><%= noticeCount %></p>
                        </div>
                        <div class="text-4xl text-pink-500">📢</div>
                    </div>
                </div>
                
                <div class="bg-white dark:bg-gray-800 p-6 rounded-2xl shadow-lg border-l-4 border-red-500 transform hover:scale-105 transition-transform duration-300">
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-700 dark:text-gray-300 mb-2">관리자 수</h3>
                            <p class="text-3xl font-bold text-red-600 dark:text-red-400"><%= adminCount %></p>
                        </div>
                        <div class="text-4xl text-red-500">👑</div>
                    </div>
                </div>
            </div>
            <!-- 작업 -->
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-6">
                <h3 class="text-xl font-bold text-gray-800 dark:text-white mb-4">빠른 작업</h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-6 gap-4">
                    <a href="admin.jsp?view=users" class="p-4 bg-blue-50 dark:bg-blue-900/20 rounded-xl hover:bg-blue-100 dark:hover:bg-blue-900/30 transition-colors duration-200">
                        <div class="text-center">
                            <div class="text-2xl mb-2">👥</div>
                            <p class="font-medium text-gray-700 dark:text-gray-300">사용자 관리</p>
                        </div>
                    </a>
                    <a href="admin.jsp?view=posts" class="p-4 bg-green-50 dark:bg-green-900/20 rounded-xl hover:bg-green-100 dark:hover:bg-green-900/30 transition-colors duration-200">
                        <div class="text-center">
                            <div class="text-2xl mb-2">📝</div>
                            <p class="font-medium text-gray-700 dark:text-gray-300">게시판 관리</p>
                        </div>
                    </a>
                    <a href="admin.jsp?view=community" class="p-4 bg-purple-50 dark:bg-purple-900/20 rounded-xl hover:bg-purple-100 dark:hover:bg-purple-900/30 transition-colors duration-200">
                        <div class="text-center">
                            <div class="text-2xl mb-2">💬</div>
                            <p class="font-medium text-gray-700 dark:text-gray-300">커뮤니티 관리</p>
                        </div>
                    </a>
                    <a href="admin.jsp?view=comments" class="p-4 bg-orange-50 dark:bg-orange-900/20 rounded-xl hover:bg-orange-100 dark:hover:bg-orange-900/30 transition-colors duration-200">
                        <div class="text-center">
                            <div class="text-2xl mb-2">💭</div>
                            <p class="font-medium text-gray-700 dark:text-gray-300">댓글 관리</p>
                        </div>
                    </a>
                    <a href="admin.jsp?view=notices" class="p-4 bg-pink-50 dark:bg-pink-900/20 rounded-xl hover:bg-pink-100 dark:hover:bg-pink-900/30 transition-colors duration-200">
                        <div class="text-center">
                            <div class="text-2xl mb-2">📢</div>
                            <p class="font-medium text-gray-700 dark:text-gray-300">공지사항 관리</p>
                        </div>
                    </a>
                    <a href="community.jsp" class="p-4 bg-yellow-50 dark:bg-yellow-900/20 rounded-xl hover:bg-yellow-100 dark:hover:bg-yellow-900/30 transition-colors duration-200">
                        <div class="text-center">
                            <div class="text-2xl mb-2">🌐</div>
                            <p class="font-medium text-gray-700 dark:text-gray-300">커뮤니티 보기</p>
                        </div>
                    </a>
                </div>
            </div>
            
        <% } else if ("users".equals(currentView)) { %>
            <!-- 사용자 관리 -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">사용자 관리</h2>
                <p class="text-gray-600 dark:text-gray-400">등록된 사용자들을 관리하세요</p>
            </div>
            
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-50 dark:bg-gray-700">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">사용자명</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">이메일</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">관리자 권한</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">작업</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection(url, user, password);
                                    
                                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users ORDER BY id");
                                    ResultSet rs = stmt.executeQuery();
                                    
                                    while (rs.next()) {
                            %>
                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-200">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white"><%= rs.getInt("id") %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center text-white text-sm font-medium mr-3">
                                            <%= rs.getString("username").substring(0, 1).toUpperCase() %>
                                        </div>
                                        <%= rs.getString("username") %>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                                    <%= rs.getString("email") != null ? rs.getString("email") : "-" %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                                    <% if (rs.getBoolean("is_admin")) { %>
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400">
                                            관리자
                                        </span>
                                    <% } else { %>
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                                            일반사용자
                                        </span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <div class="flex gap-2">
                                        <button onclick="toggleUserRole(<%= rs.getInt("id") %>, <%= !rs.getBoolean("is_admin") %>)" 
                                                class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-lg hover:bg-yellow-200 dark:bg-yellow-900/30 dark:text-yellow-400 dark:hover:bg-yellow-900/50 transition-colors duration-200">
                                            <%= rs.getBoolean("is_admin") ? "관리자 해제" : "관리자 승격" %>
                                        </button>
                                        <button onclick="deleteUser(<%= rs.getInt("id") %>)" 
                                                class="px-3 py-1 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 dark:bg-red-900/30 dark:text-red-400 dark:hover:bg-red-900/50 transition-colors duration-200">
                                            삭제
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                    conn.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

        <% } else if ("posts".equals(currentView)) { %>
            <!-- 게시판 관리 -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">게시판 관리</h2>
                <p class="text-gray-600 dark:text-gray-400">일반 게시판의 모든 게시글을 수정하고 삭제할 수 있습니다</p>
            </div>
            
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-50 dark:bg-gray-700">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">제목</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">내용</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">위치</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">관리자 작업</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection(url, user, password);
                                    
                                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM posts ORDER BY id DESC");
                                    ResultSet rs = stmt.executeQuery();
                                    
                                    while (rs.next()) {
                            %>
                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-200">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white"><%= rs.getInt("id") %></td>
                                <td class="px-6 py-4 text-sm text-gray-700 dark:text-gray-300">
                                    <div class="max-w-xs truncate">
                                        <%= rs.getString("title") != null ? (rs.getString("title").length() > 30 ? rs.getString("title").substring(0, 30) + "..." : rs.getString("title")) : "제목 없음" %>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-sm text-gray-500 dark:text-gray-400">
                                    <div class="max-w-xs truncate">
                                        <%= rs.getString("content") != null ? (rs.getString("content").length() > 40 ? rs.getString("content").substring(0, 40) + "..." : rs.getString("content")) : "내용 없음" %>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-sm text-gray-500 dark:text-gray-400">
                                    <% if (rs.getString("address") != null && !rs.getString("address").trim().isEmpty()) { %>
                                        <div class="flex items-center">
                                            <span class="mr-1">📍</span>
                                            <span class="max-w-xs truncate"><%= rs.getString("address") %></span>
                                        </div>
                                    <% } else { %>
                                        <span class="text-gray-400">-</span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <div class="flex gap-2">
                                        <button onclick="viewPost(<%= rs.getInt("id") %>, '<%= rs.getString("title") != null ? rs.getString("title").replace("'", "\\'") : "" %>', '<%= rs.getString("content") != null ? rs.getString("content").replace("'", "\\'").replace("\n", "\\n") : "" %>', '<%= rs.getString("address") != null ? rs.getString("address").replace("'", "\\'") : "" %>')" 
                                                class="px-3 py-1 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 dark:bg-blue-900/30 dark:text-blue-400 dark:hover:bg-blue-900/50 transition-colors duration-200">
                                            보기
                                        </button>
                                        <button onclick="editPost(<%= rs.getInt("id") %>, '<%= rs.getString("title") != null ? rs.getString("title").replace("'", "\\'") : "" %>', '<%= rs.getString("content") != null ? rs.getString("content").replace("'", "\\'").replace("\n", "\\n") : "" %>', '<%= rs.getString("address") != null ? rs.getString("address").replace("'", "\\'") : "" %>')" 
                                                class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-lg hover:bg-yellow-200 dark:bg-yellow-900/30 dark:text-yellow-400 dark:hover:bg-yellow-900/50 transition-colors duration-200">
                                            수정
                                        </button>
                                        <button onclick="deletePost(<%= rs.getInt("id") %>)" 
                                                class="px-3 py-1 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 dark:bg-red-900/30 dark:text-red-400 dark:hover:bg-red-900/50 transition-colors duration-200">
                                            삭제
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                    conn.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

        <% } else if ("community".equals(currentView)) { %>
            <!-- 커뮤니티 관리 -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">커뮤니티 게시글 관리</h2>
                <p class="text-gray-600 dark:text-gray-400">커뮤니티 게시글을 관리하세요</p>
            </div>
            
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-50 dark:bg-gray-700">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">제목</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">작성자</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">작성일</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">좋아요</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">댓글</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">작업</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection(url, user, password);
                                    
                                    String sql = "SELECT cp.*, u.username, " +
                                               "(SELECT COUNT(*) FROM post_likes pl WHERE pl.post_id = cp.id) as like_count, " +
                                               "(SELECT COUNT(*) FROM comments c WHERE c.post_id = cp.id) as comment_count " +
                                               "FROM community_posts cp " +
                                               "JOIN users u ON cp.user_id = u.id " +
                                               "ORDER BY cp.created_at DESC";
                                    
                                    PreparedStatement stmt = conn.prepareStatement(sql);
                                    ResultSet rs = stmt.executeQuery();
                                    
                                    while (rs.next()) {
                            %>
                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-200">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white"><%= rs.getInt("id") %></td>
                                <td class="px-6 py-4 text-sm text-gray-700 dark:text-gray-300">
                                    <div class="max-w-xs">
                                        <div class="font-medium truncate"><%= rs.getString("title") %></div>
                                        <div class="text-gray-500 dark:text-gray-400 text-xs truncate"><%= rs.getString("content").length() > 50 ? rs.getString("content").substring(0, 50) + "..." : rs.getString("content") %></div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 bg-purple-500 rounded-full flex items-center justify-center text-white text-sm font-medium mr-3">
                                            <%= rs.getString("username").substring(0, 1).toUpperCase() %>
                                        </div>
                                        <%= rs.getString("username") %>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400"><%= rs.getTimestamp("created_at") %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400">
                                        ❤️ <%= rs.getInt("like_count") %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400">
                                        💬 <%= rs.getInt("comment_count") %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <div class="flex gap-2">
                                        <button onclick="viewCommunityPost(<%= rs.getInt("id") %>, '<%= rs.getString("title").replace("'", "\\'") %>', '<%= rs.getString("content").replace("'", "\\'").replace("\n", "\\n") %>', '<%= rs.getString("username") %>', '<%= rs.getTimestamp("created_at") %>')" 
                                                class="px-3 py-1 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 dark:bg-blue-900/30 dark:text-blue-400 dark:hover:bg-blue-900/50 transition-colors duration-200">
                                            보기
                                        </button>
                                        <button onclick="deleteCommunityPost(<%= rs.getInt("id") %>)" 
                                                class="px-3 py-1 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 dark:bg-red-900/30 dark:text-red-400 dark:hover:bg-red-900/50 transition-colors duration-200">
                                            삭제
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                    conn.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

        <% } else if ("comments".equals(currentView)) { %>
            <!-- 댓글 관리 -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">댓글 관리</h2>
                <p class="text-gray-600 dark:text-gray-400">모든 댓글을 수정하고 삭제할 수 있습니다</p>
            </div>
            
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-50 dark:bg-gray-700">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">댓글 내용</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">작성자</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">게시글</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">작성일</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">관리자 작업</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection(url, user, password);
                                    
                                    String sql = "SELECT c.*, u.username, cp.title as post_title " +
                                               "FROM comments c " +
                                               "JOIN users u ON c.user_id = u.id " +
                                               "JOIN community_posts cp ON c.post_id = cp.id " +
                                               "ORDER BY c.created_at DESC";
                                    
                                    PreparedStatement stmt = conn.prepareStatement(sql);
                                    ResultSet rs = stmt.executeQuery();
                                    
                                    while (rs.next()) {
                            %>
                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-200">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white"><%= rs.getInt("id") %></td>
                                <td class="px-6 py-4 text-sm text-gray-700 dark:text-gray-300">
                                    <div class="max-w-xs">
                                        <p class="break-words"><%= rs.getString("content") %></p>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center text-white text-sm font-medium mr-3">
                                            <%= rs.getString("username").substring(0, 1).toUpperCase() %>
                                        </div>
                                        <%= rs.getString("username") %>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-sm text-gray-500 dark:text-gray-400">
                                    <div class="max-w-xs truncate"><%= rs.getString("post_title") %></div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400"><%= rs.getTimestamp("created_at") %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <div class="flex gap-2">
                                        <button onclick="editComment(<%= rs.getInt("id") %>, '<%= rs.getString("content").replace("'", "\\'").replace("\n", "\\n") %>')" 
                                                class="px-3 py-1 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 dark:bg-blue-900/30 dark:text-blue-400 dark:hover:bg-blue-900/50 transition-colors duration-200">
                                            수정
                                        </button>
                                        <button onclick="deleteComment(<%= rs.getInt("id") %>)" 
                                                class="px-3 py-1 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 dark:bg-red-900/30 dark:text-red-400 dark:hover:bg-red-900/50 transition-colors duration-200">
                                            삭제
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                    conn.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

        <% } else if ("notices".equals(currentView)) { %>
            <!-- 공지사항 관리 -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">공지사항 관리</h2>
                <p class="text-gray-600 dark:text-gray-400">외부 사이트에서 공지사항을 크롤링하고 관리하세요</p>
            </div>

            <!-- 크롤링 버튼 -->
            <div class="mb-6">
                <button onclick="crawlNotices()" 
                        class="px-6 py-3 bg-gradient-to-r from-green-600 to-blue-600 text-white rounded-lg hover:from-green-700 hover:to-blue-700 transition-all duration-200 transform hover:scale-105 flex items-center gap-2">
                    <span class="text-lg">🚀</span>
                    공지사항 크롤링 및 저장
                </button>
            </div>

            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-50 dark:bg-gray-700">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">제목</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">출처</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">등록일</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">링크</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">관리자 작업</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                            <%
                                try {
                                    NoticeDAO noticeDAO = new NoticeDAO();
                                    List<Notice> notices = noticeDAO.getAllNotices();
                                    
                                    for (Notice notice : notices) {
                            %>
                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-200">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white"><%= notice.getId() %></td>
                                <td class="px-6 py-4 text-sm text-gray-700 dark:text-gray-300">
                                    <div class="max-w-xs">
                                        <div class="font-medium truncate"><%= notice.getTitle() %></div>
                                        <div class="text-gray-500 dark:text-gray-400 text-xs truncate">
                                            <%= notice.getContent() != null ? (notice.getContent().length() > 50 ? notice.getContent().substring(0, 50) + "..." : notice.getContent()) : "" %>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium 
                                          <% if ("강원창업공단".equals(notice.getSource())) { %>
                                              bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400
                                          <% } else { %>
                                              bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-400
                                          <% } %>">
                                        <%= notice.getSource() %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                                    <%= notice.getCreatedAt() %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <a href="<%= notice.getUrl() %>" target="_blank" 
                                       class="inline-flex items-center px-3 py-1 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 dark:bg-blue-900/30 dark:text-blue-400 dark:hover:bg-blue-900/50 transition-colors duration-200">
                                        <span class="mr-1">🔗</span>
                                        보기
                                    </a>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <div class="flex gap-2">
                                        <button onclick="editNotice(<%= notice.getId() %>, '<%= notice.getTitle().replace("'", "\\'") %>', '<%= notice.getContent() != null ? notice.getContent().replace("'", "\\'").replace("\n", "\\n") : "" %>', '<%= notice.getUrl() %>', '<%= notice.getSource() %>')" 
                                                class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-lg hover:bg-yellow-200 dark:bg-yellow-900/30 dark:text-yellow-400 dark:hover:bg-yellow-900/50 transition-colors duration-200">
                                            수정
                                        </button>
                                        <button onclick="deleteNotice(<%= notice.getId() %>)" 
                                                class="px-3 py-1 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 dark:bg-red-900/30 dark:text-red-400 dark:hover:bg-red-900/50 transition-colors duration-200">
                                            삭제
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </div>
</div>

<!-- 게시글 수  -->
<div id="editPostModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden opacity-0 transition-opacity duration-300">
    <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto" id="editPostModalContent">
        <div class="flex justify-between items-center p-6 border-b dark:border-gray-700">
            <h2 class="text-2xl font-bold dark:text-white">게시글 수정</h2>
            <button onclick="closeEditPostModal()" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 text-2xl transition-colors">✕</button>
        </div>
        
        <form action="admin.jsp" method="post" class="p-6">
            <input type="hidden" name="action" value="editPost">
            <input type="hidden" name="view" value="posts">
            <input type="hidden" name="postId" id="editPostId">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="md:col-span-2">
                    <label class="block text-lg font-semibold mb-2 dark:text-white">제목</label>
                    <input type="text" name="title" id="editPostTitle" required
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 bg-white dark:bg-gray-700 text-black dark:text-white">
                </div>
                
                <div class="md:col-span-2">
                    <label class="block text-lg font-semibold mb-2 dark:text-white">내용</label>
                    <textarea name="content" id="editPostContent" rows="8" required
                              class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 bg-white dark:bg-gray-700 text-black dark:text-white resize-none"></textarea>
                </div>
                
                <div class="md:col-span-2">
                    <label class="block text-lg font-semibold mb-2 dark:text-white">위치</label>
                    <input type="text" name="address" id="editPostAddress"
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 bg-white dark:bg-gray-700 text-black dark:text-white">
                </div>
            </div>
            
            <div class="flex justify-end gap-3 mt-6">
                <button type="button" onclick="closeEditPostModal()" class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600">취소</button>
                <button type="submit" class="px-6 py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-lg hover:from-purple-700 hover:to-pink-700 transition-all duration-200 font-semibold">수정 완료</button>
            </div>
        </form>
    </div>
</div>

<!-- 게시글 상세보기 모달 -->
<div id="viewPostModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden opacity-0 transition-opacity duration-300">
    <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto" id="viewPostModalContent">
        <div class="flex justify-between items-center p-6 border-b dark:border-gray-700">
            <h2 id="viewPostTitle" class="text-2xl font-bold dark:text-white"></h2>
            <button onclick="closeViewPostModal()" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 text-2xl transition-colors">✕</button>
        </div>
        
        <div class="p-6">
            <div class="space-y-4">
                <div>
                    <h3 class="text-lg font-semibold mb-2 dark:text-white">내용</h3>
                    <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4 min-h-[200px]">
                        <p id="viewPostContent" class="text-gray-700 dark:text-gray-300 leading-relaxed whitespace-pre-wrap"></p>
                    </div>
                </div>
                <div>
                    <h3 class="text-lg font-semibold mb-2 dark:text-white">위치</h3>
                    <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4">
                        <p id="viewPostAddress" class="text-gray-700 dark:text-gray-300"></p>
                    </div>
                </div>
            </div>
        </div>
        <div class="flex justify-end gap-3 p-6 border-t dark:border-gray-700">
            <button onclick="closeViewPostModal()" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600">닫기</button>
        </div>
    </div>
</div>

<!-- 댓글 수정 -->
<div id="editCommentModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden opacity-0 transition-opacity duration-300">
    <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-2xl max-w-2xl w-full" id="editCommentModalContent">
        <div class="flex justify-between items-center p-6 border-b dark:border-gray-700">
            <h2 class="text-2xl font-bold dark:text-white">댓글 수정</h2>
            <button onclick="closeEditCommentModal()" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 text-2xl transition-colors">✕</button>
        </div>
        
        <form action="admin.jsp" method="post" class="p-6">
            <input type="hidden" name="action" value="updateComment">
            <input type="hidden" name="view" value="comments">
            <input type="hidden" name="commentId" id="editCommentId">
            
            <div class="mb-6">
                <label class="block text-lg font-semibold mb-2 dark:text-white">댓글 내용</label>
                <textarea name="content" id="editCommentContent" rows="6" required
                          class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 bg-white dark:bg-gray-700 text-black dark:text-white resize-none"></textarea>
            </div>
            
            <div class="flex justify-end gap-3">
                <button type="button" onclick="closeEditCommentModal()" class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600">취소</button>
                <button type="submit" class="px-6 py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-lg hover:from-purple-700 hover:to-pink-700 transition-all duration-200 font-semibold">수정 완료</button>
            </div>
        </form>
    </div>
</div>

<!-- 커뮤니티 게시글 상세보기 -->
<div id="communityPostModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden opacity-0 transition-opacity duration-300">
    <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto transform scale-95 transition-transform duration-300" id="communityModalContent">
        <div class="flex justify-between items-center p-6 border-b dark:border-gray-700">
            <h2 id="communityModalTitle" class="text-2xl font-bold dark:text-white"></h2>
            <button onclick="closeCommunityModal()" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 text-2xl transition-colors">✕</button>
        </div>
        
        <div class="p-6">
            <div class="mb-4">
                <div class="flex items-center gap-3">
                    <div id="communityModalAvatar" class="w-10 h-10 bg-purple-500 rounded-full flex items-center justify-center text-white font-bold"></div>
                    <div>
                        <p id="communityModalAuthor" class="font-semibold text-gray-900 dark:text-white"></p>
                        <p id="communityModalDate" class="text-sm text-gray-500 dark:text-gray-400"></p>
                    </div>
                </div>
            </div>
            <div class="space-y-4">
                <div>
                    <h3 class="text-lg font-semibold mb-2 dark:text-white">내용</h3>
                    <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4 min-h-[200px]">
                        <p id="communityModalContent" class="text-gray-700 dark:text-gray-300 leading-relaxed whitespace-pre-wrap"></p>
                    </div>
                </div>
            </div>
        </div>
        <div class="flex justify-end gap-3 p-6 border-t dark:border-gray-700">
            <button onclick="closeCommunityModal()" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600">닫기</button>
        </div>
    </div>
</div>

<!-- 공지사항 수정 -->
<div id="editNoticeModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden opacity-0 transition-opacity duration-300">
    <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-2xl max-w-2xl w-full" id="editNoticeModalContent">
        <div class="flex justify-between items-center p-6 border-b dark:border-gray-700">
            <h2 class="text-2xl font-bold dark:text-white">공지사항 수정</h2>
            <button onclick="closeEditNoticeModal()" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 text-2xl transition-colors">✕</button>
        </div>
        
        <form action="admin.jsp" method="post" class="p-6">
            <input type="hidden" name="action" value="editNotice">
            <input type="hidden" name="view" value="notices">
            <input type="hidden" name="noticeId" id="editNoticeId">
            
            <div class="space-y-4">
                <div>
                    <label class="block text-lg font-semibold mb-2 dark:text-white">제목</label>
                    <input type="text" name="title" id="editNoticeTitle" required
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 bg-white dark:bg-gray-700 text-black dark:text-white">
                </div>
                
                <div>
                    <label class="block text-lg font-semibold mb-2 dark:text-white">내용</label>
                    <textarea name="content" id="editNoticeContent" rows="4" required
                              class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 bg-white dark:bg-gray-700 text-black dark:text-white resize-none"></textarea>
                </div>
                
                <div>
                    <label class="block text-lg font-semibold mb-2 dark:text-white">링크</label>
                    <input type="url" name="url" id="editNoticeUrl" required
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 bg-white dark:bg-gray-700 text-black dark:text-white">
                </div>
                
                <div>
                    <label class="block text-lg font-semibold mb-2 dark:text-white">출처</label>
                    <input type="text" name="source" id="editNoticeSource" required
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 bg-white dark:bg-gray-700 text-black dark:text-white">
                </div>
            </div>
            
            <div class="flex justify-end gap-3 mt-6">
                <button type="button" onclick="closeEditNoticeModal()" class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600">취소</button>
                <button type="submit" class="px-6 py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-lg hover:from-purple-700 hover:to-pink-700 transition-all duration-200 font-semibold">수정 완료</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script>
	// 크롤링
	function crawlNotices() {
	    if (confirm('공지사항을 크롤링하고 데이터베이스에 저장하시겠습니까?')) {
	        window.location.href = 'admin.jsp?action=crawlNotices&view=notices';
	    }
	}
	
	// 게시글 수정
	function editPost(postId, title, content, address) {
	    const modal = document.getElementById('editPostModal');
	    const modalContent = document.getElementById('editPostModalContent');
	    
	    document.getElementById('editPostId').value = postId;
	    document.getElementById('editPostTitle').value = title;
	    document.getElementById('editPostContent').value = content;
	    document.getElementById('editPostAddress').value = address;
	    
	    modal.classList.remove('hidden');
	    setTimeout(() => {
	        modal.classList.remove('opacity-0');
	        modalContent.classList.remove('scale-95');
	        modalContent.classList.add('scale-100');
	    }, 10);
	    
	    document.body.style.overflow = 'hidden';
	}
	
	function closeEditPostModal() {
	    const modal = document.getElementById('editPostModal');
	    const modalContent = document.getElementById('editPostModalContent');
	    
	    modal.classList.add('opacity-0');
	    modalContent.classList.remove('scale-100');
	    modalContent.classList.add('scale-95');
	    
	    setTimeout(() => {
	        modal.classList.add('hidden');
	    }, 300);
	    
	    document.body.style.overflow = 'auto';
	}
	
	// 게시글 상세
	function viewPost(postId, title, content, address) {
	    const modal = document.getElementById('viewPostModal');
	    const modalContent = document.getElementById('viewPostModalContent');
	    
	    document.getElementById('viewPostTitle').textContent = title || '제목 없음';
	    document.getElementById('viewPostContent').textContent = content || '내용 없음';
	    document.getElementById('viewPostAddress').textContent = address || '위치 정보 없음';
	    
	    modal.classList.remove('hidden');
	    setTimeout(() => {
	        modal.classList.remove('opacity-0');
	        modalContent.classList.remove('scale-95');
	        modalContent.classList.add('scale-100');
	    }, 10);
	    
	    document.body.style.overflow = 'hidden';
	}
	
	function closeViewPostModal() {
	    const modal = document.getElementById('viewPostModal');
	    const modalContent = document.getElementById('viewPostModalContent');
	    
	    modal.classList.add('opacity-0');
	    modalContent.classList.remove('scale-100');
	    modalContent.classList.add('scale-95');
	    
	    setTimeout(() => {
	        modal.classList.add('hidden');
	    }, 300);
	    
	    document.body.style.overflow = 'auto';
	}
	
	// 게시글 삭제
	function deletePost(postId) {
	    if (confirm('정말 이 게시글을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
	        window.location.href = 'admin.jsp?action=deletePost&id=' + postId + '&view=posts';
	    }
	}
	
	// 댓글 수정
	function editComment(commentId, content) {
	    const modal = document.getElementById('editCommentModal');
	    const modalContent = document.getElementById('editCommentModalContent');
	    
	    document.getElementById('editCommentId').value = commentId;
	    document.getElementById('editCommentContent').value = content;
	    
	    modal.classList.remove('hidden');
	    setTimeout(() => {
	        modal.classList.remove('opacity-0');
	        modalContent.classList.remove('scale-95');
	        modalContent.classList.add('scale-100');
	    }, 10);
	    
	    document.body.style.overflow = 'hidden';
	}
	
	function closeEditCommentModal() {
	    const modal = document.getElementById('editCommentModal');
	    const modalContent = document.getElementById('editCommentModalContent');
	    
	    modal.classList.add('opacity-0');
	    modalContent.classList.remove('scale-100');
	    modalContent.classList.add('scale-95');
	    
	    setTimeout(() => {
	        modal.classList.add('hidden');
	    }, 300);
	    
	    document.body.style.overflow = 'auto';
	}
	
	// 댓글 삭제
	function deleteComment(commentId) {
	    if (confirm('정말 이 댓글을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
	        window.location.href = 'admin.jsp?action=deleteComment&id=' + commentId + '&view=comments';
	    }
	}
	
	// 커뮤니티 게시글 상세보기
	function viewCommunityPost(id, title, content, author, date) {
	    const modal = document.getElementById('communityPostModal');
	    const modalContent = document.getElementById('communityModalContent');
	    
	    document.getElementById('communityModalTitle').textContent = title;
	    document.getElementById('communityModalContent').textContent = content;
	    document.getElementById('communityModalAuthor').textContent = author;
	    document.getElementById('communityModalDate').textContent = date;
	    document.getElementById('communityModalAvatar').textContent = author.substring(0, 1).toUpperCase();
	    
	    modal.classList.remove('hidden');
	    setTimeout(() => {
	        modal.classList.remove('opacity-0');
	        modalContent.classList.remove('scale-95');
	        modalContent.classList.add('scale-100');
	    }, 10);
	    
	    document.body.style.overflow = 'hidden';
	}
	
	function closeCommunityModal() {
	    const modal = document.getElementById('communityPostModal');
	    const modalContent = document.getElementById('communityModalContent');
	    
	    modal.classList.add('opacity-0');
	    modalContent.classList.remove('scale-100');
	    modalContent.classList.add('scale-95');
	    
	    setTimeout(() => {
	        modal.classList.add('hidden');
	    }, 300);
	    
	    document.body.style.overflow = 'auto';
	}
	
	// 커뮤니티 게시글 삭제
	function deleteCommunityPost(postId) {
	    if (confirm('정말 이 커뮤니티 게시글을 삭제하시겠습니까? 관련된 모든 댓글과 좋아요도 함께 삭제됩니다.')) {
	        window.location.href = 'admin.jsp?action=deleteCommunityPost&id=' + postId + '&view=community';
	    }
	}
	
	// 공지사항 수정
	function editNotice(noticeId, title, content, url, source) {
	    const modal = document.getElementById('editNoticeModal');
	    const modalContent = document.getElementById('editNoticeModalContent');
	    
	    document.getElementById('editNoticeId').value = noticeId;
	    document.getElementById('editNoticeTitle').value = title;
	    document.getElementById('editNoticeContent').value = content;
	    document.getElementById('editNoticeUrl').value = url;
	    document.getElementById('editNoticeSource').value = source;
	    
	    modal.classList.remove('hidden');
	    setTimeout(() => {
	        modal.classList.remove('opacity-0');
	        modalContent.classList.remove('scale-95');
	        modalContent.classList.add('scale-100');
	    }, 10);
	    
	    document.body.style.overflow = 'hidden';
	}
	
	function closeEditNoticeModal() {
	    const modal = document.getElementById('editNoticeModal');
	    const modalContent = document.getElementById('editNoticeModalContent');
	    
	    modal.classList.add('opacity-0');
	    modalContent.classList.remove('scale-100');
	    modalContent.classList.add('scale-95');
	    
	    setTimeout(() => {
	        modal.classList.add('hidden');
	    }, 300);
	    
	    document.body.style.overflow = 'auto';
	}
	
	// 공지사항 삭제
	function deleteNotice(noticeId) {
	    if (confirm('정말 이 공지사항을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
	        window.location.href = 'admin.jsp?action=deleteNotice&id=' + noticeId + '&view=notices';
	    }
	}
	
	// 사용자 권한 토글
	function toggleUserRole(userId, makeAdmin) {
	    const action = makeAdmin ? '관리자로 승격' : '관리자 권한 해제';
	    if (confirm('이 사용자를 ' + action + '하시겠습니까?')) {
	        const form = document.createElement('form');
	        form.method = 'POST';
	        form.action = 'admin.jsp';
	        
	        const actionInput = document.createElement('input');
	        actionInput.type = 'hidden';
	        actionInput.name = 'action';
	        actionInput.value = 'edit_user';
	        
	        const viewInput = document.createElement('input');
	        viewInput.type = 'hidden';
	        viewInput.name = 'view';
	        viewInput.value = 'users';
	        
	        const idInput = document.createElement('input');
	        idInput.type = 'hidden';
	        idInput.name = 'id';
	        idInput.value = userId;
	        
	        const adminInput = document.createElement('input');
	        adminInput.type = 'hidden';
	        adminInput.name = 'is_admin';
	        adminInput.value = makeAdmin;
	        
	        form.appendChild(actionInput);
	        form.appendChild(viewInput);
	        form.appendChild(idInput);
	        form.appendChild(adminInput);
	        
	        document.body.appendChild(form);
	        form.submit();
	    }
	}
	
	// 사용자 삭제
	function deleteUser(userId) {
	    if (confirm('이 사용자를 삭제하시겠습니까? 사용자의 모든 게시물과 댓글도 함께 삭제됩니다.')) {
	        window.location.href = 'admin.jsp?action=delete_user&id=' + userId + '&view=users';
	    }
	}
</script>

