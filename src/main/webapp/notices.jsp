<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.NoticeDAO, java.util.*, model.Notice" %>
<%
    NoticeDAO noticeDAO = new NoticeDAO();
    List<Notice> notices = new ArrayList<>();
    notices = noticeDAO.getAllNotices();
    String userRole = (String) session.getAttribute("userRole");
%>

<%@ include file="header.jsp" %>

<main class="pt-20 min-h-screen bg-gray-50 dark:bg-gray-900">
    <div class="max-w-7xl mx-auto px-4 py-8">
        <div class="mb-8">
            <div class="flex justify-between items-center">
                <div>
                    <h1 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">📢 공지사항</h1>
                    <p class="text-gray-600 dark:text-gray-400">창업 관련 최신 공지사항을 확인하세요</p>
                    <p class="text-sm text-gray-500 dark:text-gray-500 mt-1">총 <span class="font-semibold text-blue-600"><%= notices.size() %>개</span>의 공지사항이 있습니다</p>
                </div>
            </div>
        </div>
        
        <% if (!notices.isEmpty()) { %>
        <div>
            <h2 class="text-2xl font-bold text-gray-800 dark:text-white mb-6">📋 전체 공지사항</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                <% 
                    int cardCount = 0;
                    for (Notice notice : notices) { 
                        if (cardCount < 6) {
                %>
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 p-6 border-l-4 <%= "강원창업공단".equals(notice.getSource()) ? "border-green-500" : "border-purple-500" %>">
                    <div class="flex items-center justify-between mb-3">
                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium <%= "강원창업공단".equals(notice.getSource()) ? "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400" : "bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-400" %>">
                            <%= notice.getSource() %>
                        </span>
                        <span class="text-xs text-gray-500 dark:text-gray-400">
                            <%= notice.getCreatedAt() != null ? new java.text.SimpleDateFormat("MM/dd").format(notice.getCreatedAt()) : "최근" %>
                        </span>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-800 dark:text-white mb-3 line-clamp-2 leading-tight">
                        <%= notice.getTitle() %>
                    </h3>
                    <% if (notice.getContent() != null && !notice.getContent().isEmpty()) { %>
                    <p class="text-gray-600 dark:text-gray-400 text-sm mb-4 line-clamp-3">
                        <%= notice.getContent().length() > 100 ? notice.getContent().substring(0, 100) + "..." : notice.getContent() %>
                    </p>
                    <% } %>
                    <% if (notice.getUrl() != null && !notice.getUrl().isEmpty()) { %>
                    <a href="<%= notice.getUrl() %>" target="_blank" 
                       class="inline-flex items-center px-4 py-2 bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400 rounded-lg hover:bg-blue-200 dark:hover:bg-blue-900/50 transition-colors duration-200 text-sm font-medium">
                        <span class="mr-1">🔗</span>
                        자세히 보기
                    </a>
                    <% } %>
                </div>
                <%
                        cardCount++;
                        }
                    }
                %>
            </div>
            
            <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg overflow-hidden">
                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-700 border-b dark:border-gray-600">
                    <h3 class="text-lg font-semibold text-gray-800 dark:text-white">전체 공지사항 목록</h3>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-50 dark:bg-gray-700">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">출처</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">제목</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">등록일</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">링크</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                            <% for (Notice notice : notices) { %>
                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-200">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium 
                                          <% if ("강원창업공단".equals(notice.getSource())) { %>
                                              bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400
                                          <% } else { %>
                                              bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-400
                                          <% } %>">
                                        <%= notice.getSource() %>
                                    </span>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm font-medium text-gray-900 dark:text-white">
                                        <%= notice.getTitle() %>
                                    </div>
                                    <% if (notice.getContent() != null && !notice.getContent().isEmpty()) { %>
                                    <div class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                                        <%= notice.getContent().length() > 80 ? notice.getContent().substring(0, 80) + "..." : notice.getContent() %>
                                    </div>
                                    <% } %>
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
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="text-center py-16 bg-white dark:bg-gray-800 rounded-xl shadow-lg">
            <div class="text-gray-400 text-6xl mb-4">📋</div>
            <h3 class="text-xl font-semibold text-gray-600 dark:text-gray-400 mb-2">공지사항이 없습니다</h3>
            <p class="text-gray-500 dark:text-gray-500 mb-4">아직 등록된 공지사항이 없습니다.</p>
            
            <% if ("admin".equals(userRole)) { %>
            <div class="space-y-2">
                <p class="text-sm text-gray-600 dark:text-gray-400">관리자는 아래 버튼을 통해 공지사항을 추가할 수 있습니다.</p>
                <div class="flex justify-center gap-3">
                    <a href="admin.jsp?view=notices" 
                       class="px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors">
                        ⚙️ 관리자 패널
                    </a>
                </div>
            </div>
            <% } else { %>
            <p class="text-sm text-gray-500">곧 새로운 공지사항이 업데이트될 예정입니다.</p>
            <% } %>
        </div>
        <% } %>
        
        <% if (!notices.isEmpty()) { %>
        <div class="mt-12 bg-gradient-to-r from-blue-50 to-purple-50 dark:from-blue-900/20 dark:to-purple-900/20 rounded-xl p-6">
            <div class="text-center">
                <h3 class="text-lg font-semibold text-gray-800 dark:text-white mb-2">📬 공지사항 알림</h3>
                <p class="text-gray-600 dark:text-gray-400 text-sm">
                    새로운 창업 지원 프로그램과 공모전 정보를 놓치지 마세요!<br>
                    정기적으로 공지사항을 확인하여 다양한 기회를 잡으시기 바랍니다.
                </p>
                <div class="mt-4 flex justify-center gap-4 text-sm text-gray-500 dark:text-gray-400">
                    <span>🏢 강원창업공단</span>
                    <span>🚀 K-스타트업</span>
                    <span>📊 기타 기관</span>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</main>

<%@ include file="footer.jsp" %>

<style>
	.line-clamp-2 {
	    display: -webkit-box;
	    -webkit-line-clamp: 2;
	    -webkit-box-orient: vertical;
	    overflow: hidden;
	}
	
	.line-clamp-3 {
	    display: -webkit-box;
	    -webkit-line-clamp: 3;
	    -webkit-box-orient: vertical;
	    overflow: hidden;
	}
	
	@media (max-width: 768px) {
	    .transform.hover\:scale-105:hover {
	        transform: scale(1.02);
	    }
	}
</style>
 