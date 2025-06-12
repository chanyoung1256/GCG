<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <footer class="bg-white dark:bg-gray-900 text-gray-500 dark:text-gray-300 text-center py-6 mt-16 border-t dark:border-gray-700">
        <p>한림대학교 빅데이터학과 20235147 김찬영</p>
    </footer>

    <script>
	    window.addEventListener('scroll', function() {
	        const header = document.getElementById('main-header');
	        if (window.scrollY > 60) {
	            header.classList.remove('bg-transparent', 'text-white');
	            header.classList.add('bg-white', 'text-gray-900', 'shadow-md');
	        } else {
	            header.classList.remove('bg-white', 'text-gray-900', 'shadow-md');
	            header.classList.add('bg-transparent', 'text-white');
	        }
	    });
	
	    // 영상 무한 반복
	    document.addEventListener('DOMContentLoaded', function() {
	        const video = document.getElementById('main-video');
	        if (video) {
	            video.addEventListener('ended', function() {
	                video.currentTime = 0;
	                video.play();
	            });
	        }
	
	        const toggleBtn = document.getElementById('theme-toggle');
	        const icon = document.getElementById('theme-toggle-icon');
	        const root = document.documentElement;
	        
	        if (localStorage.getItem('theme') === 'dark') {
	            root.classList.add('dark');
	            icon.textContent = '☀️';
	        } else {
	            root.classList.remove('dark');
	            icon.textContent = '🌙';
	        }
	
	        toggleBtn.addEventListener('click', function() {
	            root.classList.toggle('dark');
	            if (root.classList.contains('dark')) {
	                localStorage.setItem('theme', 'dark');
	                icon.textContent = '☀️';
	            } else {
	                localStorage.setItem('theme', 'light');
	                icon.textContent = '🌙';
	            }
	        });
	    });
    </script>
</body>
</html>

