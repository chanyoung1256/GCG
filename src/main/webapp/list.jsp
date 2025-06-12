<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO, java.util.*, model.Post" %>
<%
    BoardDAO dao = new BoardDAO();
    List<Post> postList = dao.getAllPosts();
%>

<%@ include file="header.jsp" %>
    <main class="max-w-7xl mx-auto pt-24 pb-16 px-4">
        <div class="flex justify-between items-center mb-10">
            <h2 class="text-2xl font-bold dark:text-white">게시물 목록</h2>
            <% if (username != null) { %>
				<a href="write.jsp" class="px-5 py-2 rounded-lg bg-gradient-to-r from-purple-600 to-pink-600 text-white font-semibold shadow-lg hover:from-purple-700 hover:to-pink-700 transform hover:scale-105 transition-all duration-200 dark:from-indigo-500 dark:to-purple-600 dark:hover:from-indigo-600 dark:hover:purple-700">
				    게시물 작성
				</a> 
            <% } %>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8">
            <%
                if (postList != null && !postList.isEmpty()) {
                    for (Post post : postList) {
                        String imgPath = post.getImagePath();
                        String address = post.getAddress();
                        String createdAt = post.getCreatedAt();
            %>
            <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-lg p-6 flex flex-col items-start border-t-4 border-blue-500 cursor-pointer hover:shadow-xl transition-shadow duration-300"
                 onclick="openModal(<%= post.getId() %>, '<%= post.getTitle() != null ? post.getTitle().replace("'", "\\'") : "" %>', '<%= post.getContent() != null ? post.getContent().replace("'", "\\'").replace("\n", "\\n") : "" %>', '<%= createdAt != null ? createdAt : "" %>', '<%= imgPath != null ? imgPath : "" %>', '<%= address != null ? address.replace("'", "\\'") : "" %>')">
                <% if (imgPath != null && !imgPath.trim().isEmpty()) { %>
                    <img src="<%= imgPath %>" alt="게시물 이미지" class="w-full h-40 object-cover rounded mb-4 bg-gray-200 dark:bg-gray-800" />
                <% } %>
                <h3 class="font-bold text-lg mb-2 truncate dark:text-white"><%= post.getTitle() != null ? post.getTitle() : "제목 없음" %></h3>
                <p class="text-gray-600 text-sm mb-2 line-clamp-2 dark:text-gray-300"><%= post.getContent() != null ? post.getContent() : "" %></p>

                <% if (address != null && !address.trim().isEmpty()) { %>
                    <div class="flex items-center mb-2 text-sm text-gray-500 dark:text-gray-400 w-full">
                        <span class="mr-1">📍</span>
                        <span class="truncate"><%= address %></span>
                    </div>
                <% } %>
                
                <div class="flex items-center justify-between w-full mt-auto">
                    <span class="text-xs text-gray-400 dark:text-gray-500">작성일: <%= createdAt != null ? createdAt : "정보 없음" %></span>
                    <span class="text-blue-600 font-semibold dark:text-blue-400">자세히 보기 →</span>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="col-span-full text-center text-gray-400 dark:text-gray-500 py-16">
                게시물이 없습니다.
            </div>
            <%
                }
            %>
        </div>
    </main>

    <div id="postModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden opacity-0 transition-opacity duration-300">
        <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto transform scale-95 transition-transform duration-300" id="modalContent">
            <div class="flex justify-between items-center p-6 border-b dark:border-gray-700">
                <h2 id="modalTitle" class="text-2xl font-bold dark:text-white"></h2>
                <button onclick="closeModal()" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 text-2xl transition-colors">
                    ✕
                </button>
            </div>
            <div class="p-6">
                <div id="modalImageContainer" class="mb-6 hidden">
                    <img id="modalImage" src="" alt="게시물 이미지" class="w-full max-h-96 object-contain rounded-lg bg-gray-100 dark:bg-gray-800" />
                </div>
                <div id="modalAddressContainer" class="mb-4 hidden">
                    <h3 class="text-lg font-semibold mb-2 dark:text-white">위치</h3>
                    <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-3">
                        <div class="flex items-center">
                            <span class="text-red-500 mr-2">📍</span>
                            <span id="modalAddress" class="text-gray-700 dark:text-gray-300"></span>
                        </div>
                    </div>
                </div>
                
                <div class="space-y-4">
                    <div>
                        <h3 class="text-lg font-semibold mb-2 dark:text-white">내용</h3>
                        <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4 min-h-[200px]">
                            <p id="modalContentText" class="text-gray-700 dark:text-gray-300 leading-relaxed whitespace-pre-wrap"></p>
                        </div>
                    </div>
                    
                    <div class="flex justify-between items-center pt-4 border-t dark:border-gray-700">
                        <div class="text-sm text-gray-500 dark:text-gray-400">
                            <span>게시물 ID: </span><span id="modalPostId"></span>
                        </div>
                        <div class="text-sm text-gray-500 dark:text-gray-400">
                            <span>작성일: </span><span id="modalCreatedAt"></span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="flex justify-end gap-3 p-6 border-t dark:border-gray-700">
                <button onclick="closeModal()" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600">
                    닫기
                </button>
                <button onclick="showAdminAlert()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors dark:bg-yellow-400 dark:text-black dark:hover:bg-yellow-500">
                    수정하기
                </button>
            </div>
        </div>
    </div>

    <div id="adminAlertModal" class="fixed inset-0 bg-black bg-opacity-60 flex items-center justify-center p-4 z-60 hidden opacity-0 transition-opacity duration-300">
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-md w-full transform scale-95 transition-transform duration-300" id="adminAlertContent">
            <div class="flex items-center justify-center p-6 border-b dark:border-gray-700">
                <div class="flex items-center">
                    <span class="text-4xl mr-3">🚫</span>
                    <h2 class="text-xl font-bold text-red-600 dark:text-red-400">접근 제한</h2>
                </div>
            </div>
          
            <div class="p-6 text-center">
                <div class="mb-4">
                    <p class="text-gray-700 dark:text-gray-300 text-lg mb-2">
                        <strong>관리자 권한이 필요합니다</strong>
                    </p>
                    <p class="text-gray-600 dark:text-gray-400 text-sm">
                        게시물 수정 기능은 관리자만 사용할 수 있습니다.<br>
                        관리자 계정으로 로그인 후 다시 시도해주세요.
                    </p>
                </div>
                
                <div class="bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-lg p-3 mb-4">
                    <div class="flex items-start">
                        <span class="text-yellow-500 mr-2 mt-0.5">⚠️</span>
                        <div class="text-sm text-yellow-700 dark:text-yellow-300">
                            <p class="font-medium">관리자 문의:</p>
                            <p>010-6333-1256</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="flex justify-center gap-3 p-6 border-t dark:border-gray-700">
                <button onclick="closeAdminAlert()" class="px-6 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600">
                    확인
                </button>
                <button onclick="redirectToLogin()" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors dark:bg-blue-500 dark:hover:bg-blue-600">
                    로그인 페이지로
                </button>
            </div>
        </div>
    </div>
    
<%@ include file="footer.jsp" %>

<script>
	function openModal(id, title, content, createdAt, imagePath, address) {
	    const modal = document.getElementById('postModal');
	    const modalContent = document.getElementById('modalContent');
	    
	    document.getElementById('modalTitle').textContent = title || '제목 없음';
	    document.getElementById('modalContentText').textContent = content || '내용 없음';
	    document.getElementById('modalPostId').textContent = id;
	    document.getElementById('modalCreatedAt').textContent = createdAt || '정보 없음';
	    
	    const addressContainer = document.getElementById('modalAddressContainer');
	    const modalAddress = document.getElementById('modalAddress');
	    
	    if (address && address.trim() !== '') {
	        modalAddress.textContent = address;
	        addressContainer.classList.remove('hidden');
	    } else {
	        addressContainer.classList.add('hidden');
	    }

	    const imageContainer = document.getElementById('modalImageContainer');
	    const modalImage = document.getElementById('modalImage');
	    
	    if (imagePath && imagePath.trim() !== '') {
	        modalImage.src = imagePath;
	        imageContainer.classList.remove('hidden');
	    } else {
	        imageContainer.classList.add('hidden');
	    }
	    
	    modal.classList.remove('hidden');
	    setTimeout(() => {
	        modal.classList.remove('opacity-0');
	        modalContent.classList.remove('scale-95');
	        modalContent.classList.add('scale-100');
	    }, 10);

	    document.body.style.overflow = 'hidden';
	}
	
	function closeModal() {
	    const modal = document.getElementById('postModal');
	    const modalContent = document.getElementById('modalContent');
	    
	    modal.classList.add('opacity-0');
	    modalContent.classList.remove('scale-100');
	    modalContent.classList.add('scale-95');
	    
	    setTimeout(() => {
	        modal.classList.add('hidden');
	    }, 300);
	    
	    document.body.style.overflow = 'auto';
	}
	
	function showAdminAlert() {
	    const alertModal = document.getElementById('adminAlertModal');
	    const alertContent = document.getElementById('adminAlertContent');
	    
	    alertModal.classList.remove('hidden');
	    setTimeout(() => {
	        alertModal.classList.remove('opacity-0');
	        alertContent.classList.remove('scale-95');
	        alertContent.classList.add('scale-100');
	    }, 10);
	}
	
	function closeAdminAlert() {
	    const alertModal = document.getElementById('adminAlertModal');
	    const alertContent = document.getElementById('adminAlertContent');
	    
	    alertModal.classList.add('opacity-0');
	    alertContent.classList.remove('scale-100');
	    alertContent.classList.add('scale-95');
	    
	    setTimeout(() => {
	        alertModal.classList.add('hidden');
	    }, 300);
	}
	
	function redirectToLogin() {
	    closeAdminAlert();
	    closeModal();
	    window.location.href = 'login.jsp';
	}
	
	document.addEventListener('keydown', function(event) {
	    if (event.key === 'Escape') {
	        if (!document.getElementById('adminAlertModal').classList.contains('hidden')) {
	            closeAdminAlert();
	        } else {
	            closeModal();
	        }
	    }
	});
	
	document.getElementById('postModal').addEventListener('click', function(event) {
	    if (event.target === this) {
	        closeModal();
	    }
	});
	
	document.getElementById('adminAlertModal').addEventListener('click', function(event) {
	    if (event.target === this) {
	        closeAdminAlert();
	    }
	});
</script>


