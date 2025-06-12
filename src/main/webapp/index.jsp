<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO, dao.NoticeDAO, java.util.*, model.Post, model.Notice" %>
<%
    BoardDAO dao = new BoardDAO();
    List<Post> postList = dao.getAllPosts();
    NoticeDAO noticeDAO = new NoticeDAO();
    List<Notice> noticeList = noticeDAO.getAllNotices();
    List<Notice> recentNotices = noticeList.size() > 3 ? noticeList.subList(0, 3) : noticeList;
%>

<%@ include file="header.jsp" %>

    <section class="relative flex items-center justify-center h-[90vh] min-h-[600px] w-full overflow-hidden">
        <video id="main-video" autoplay loop muted playsinline class="absolute z-0 w-full h-full object-cover brightness-90">
            <source src="gcg_test.mp4" type="video/mp4" />
        </video>
        <div class="absolute inset-0 bg-black/30 z-10"></div>
        <div class="relative z-20 flex flex-col items-center text-center px-4">
            <h1 class="text-4xl md:text-5xl font-bold text-white drop-shadow">
                창업의 시작, <span class="text-blue-300">당신의 공간</span>을 찾아보세요
            </h1>
            <p class="mt-4 text-lg md:text-2xl text-white drop-shadow">
                공간·대여 및 임대, 커뮤니티, 지원정보까지 한 곳에서!
            </p>
            <div class="mt-8 flex gap-4">
                <a href="list.jsp" class="px-6 py-2 rounded bg-blue-600 text-white font-semibold shadow hover:bg-blue-700 transition">임대 찾기</a>
                <a href="about.jsp" class="px-6 py-2 rounded border border-white text-white font-semibold hover:bg-white/10">소개</a>
            </div>
        </div>
    </section>
    
    <section class="max-w-7xl mx-auto py-16 px-4">
        <h2 class="text-2xl font-bold text-center mb-10 dark:text-white"> 게시물 </h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-8">
            <%
                List<Post> shuffled = new ArrayList<>(postList);
                Collections.shuffle(shuffled);
                int majorCount = Math.min(shuffled.size(), 8);
                for (int i = 0; i < majorCount; i++) {
                    Post post = shuffled.get(i);
                    String imgPath = post.getImagePath();
            %>
            <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-lg p-6 flex flex-col items-start border-t-4 border-blue-500">
                <% if (imgPath != null && !imgPath.trim().isEmpty()) { %>
                    <img src="<%= imgPath %>" alt="게시물 이미지" class="w-full h-40 object-cover rounded mb-4" />
                <% } %>
                <h3 class="font-bold text-lg mb-2 truncate dark:text-white"><%= post.getTitle() %></h3>
                <p class="text-gray-600 text-sm mb-4 line-clamp-2 dark:text-gray-300"><%= post.getContent() %></p>
                <a href="list.jsp" class="mt-auto text-blue-600 font-semibold hover:underline dark:text-blue-400">자세히 보기 →</a>
            </div>
            <% } %>
        </div>
    </section>


    <section class="max-w-4xl mx-auto py-10 px-4">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-bold dark:text-white">📢 공지사항</h2>
            <a href="notices.jsp" class="text-blue-600 font-semibold hover:underline dark:text-blue-400">전체보기 →</a>
        </div>
        
        <% if (!recentNotices.isEmpty()) { %>
        <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-lg divide-y divide-gray-200 dark:divide-gray-700 border dark:border-gray-800">
            <% for (Notice notice : recentNotices) { %>
            <div class="flex items-center px-6 py-4 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors duration-200">
                <span class="inline-block px-3 py-1 mr-4 text-xs rounded-full font-semibold
                    <% if ("강원창업공단".equals(notice.getSource())) { %>
                        bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400
                    <% } else if ("K-스타트업".equals(notice.getSource())) { %>
                        bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400
                    <% } else { %>
                        bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400
                    <% } %>">
                    <%= notice.getSource() %>
                </span>
                <div class="flex-1 min-w-0">
                    <div class="font-semibold dark:text-white truncate">
                        <%= notice.getTitle() %>
                    </div>
                    <div class="text-gray-500 text-sm dark:text-gray-400 mt-1">
                        <%= notice.getCreatedAt() != null ? 
                            new java.text.SimpleDateFormat("yyyy.MM.dd").format(notice.getCreatedAt()) : 
                            "최근" %>
                    </div>
                </div>
                <% if (notice.getUrl() != null && !notice.getUrl().isEmpty()) { %>
                <a href="<%= notice.getUrl() %>" target="_blank" 
                   class="ml-4 text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200 flex items-center">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
                    </svg>
                </a>
                <% } %>
            </div>
            <% } %>
        </div>
        <% } else { %>

        <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-lg p-8 text-center border dark:border-gray-800">
            <div class="text-gray-400 text-4xl mb-4">📋</div>
            <h3 class="text-lg font-semibold text-gray-600 dark:text-gray-400 mb-2">공지사항이 없습니다</h3>
            <p class="text-gray-500 dark:text-gray-500 text-sm">새로운 공지사항이 업데이트되면 여기에 표시됩니다.</p>
        </div>
        <% } %>
        
        <div class="mt-6 text-center">
            <p class="text-sm text-gray-500 dark:text-gray-400">
                총 <span class="font-semibold text-blue-600 dark:text-blue-400"><%= noticeList.size() %>개</span>의 공지사항 | 
                <a href="notices.jsp" class="text-blue-600 dark:text-blue-400 hover:underline">모든 공지사항 보기</a>
            </p>
        </div>
    </section>

    <section class="max-w-6xl mx-auto py-16 px-4">
        <h2 class="text-2xl font-bold text-center mb-10 dark:text-white">빠른 바로가기</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <a href="list.jsp" class="group bg-gradient-to-br from-blue-50 to-blue-100 dark:from-blue-900/20 dark:to-blue-800/20 rounded-2xl p-8 hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1">
                <div class="text-4xl mb-4">🏢</div>
                <h3 class="text-xl font-bold mb-2 dark:text-white">공간 임대</h3>
                <p class="text-gray-600 dark:text-gray-400">창업을 위한 최적의 공간을 찾아보세요</p>
                <div class="mt-4 text-blue-600 dark:text-blue-400 group-hover:translate-x-1 transition-transform">바로가기 →</div>
            </a>
            
            <a href="community.jsp" class="group bg-gradient-to-br from-purple-50 to-purple-100 dark:from-purple-900/20 dark:to-purple-800/20 rounded-2xl p-8 hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1">
                <div class="text-4xl mb-4">💬</div>
                <h3 class="text-xl font-bold mb-2 dark:text-white">커뮤니티</h3>
                <p class="text-gray-600 dark:text-gray-400">창업자들과 소통하고 정보를 공유하세요</p>
                <div class="mt-4 text-purple-600 dark:text-purple-400 group-hover:translate-x-1 transition-transform">바로가기 →</div>
            </a>
            
            <a href="notices.jsp" class="group bg-gradient-to-br from-green-50 to-green-100 dark:from-green-900/20 dark:to-green-800/20 rounded-2xl p-8 hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1">
                <div class="text-4xl mb-4">📢</div>
                <h3 class="text-xl font-bold mb-2 dark:text-white">공지사항</h3>
                <p class="text-gray-600 dark:text-gray-400">최신 창업 지원 정보를 확인하세요</p>
                <div class="mt-4 text-green-600 dark:text-green-400 group-hover:translate-x-1 transition-transform">바로가기 →</div>
            </a>
        </div>
    </section>

<%@ include file="footer.jsp" %>

<style>
.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
</style>


