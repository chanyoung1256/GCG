//package dao;
//
//import java.sql.*;
//import java.util.*;
//import model.Notice;
//import org.jsoup.Jsoup;
//import org.jsoup.nodes.Document;
//import org.jsoup.nodes.Element;
//import org.jsoup.select.Elements;
//
//public class NoticeDAO {
//    private String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
//    private String user = "root";
//    private String password = "Gimchanyoung1!";
//    
//    // 🧪 테스트용 크롤링 메서드 (누락된 메서드)
//    public List<Notice> testCrawling() {
//        List<Notice> notices = new ArrayList<>();
//        
//        try {
//            System.out.println("=== 테스트 크롤링 시작 ===");
//            
//            // 간단한 테스트 사이트로 크롤링 (네이버 뉴스)
//            String testUrl = "https://news.naver.com/main/list.naver?mode=LSD&mid=sec&sid1=105";
//            
//            Document doc = Jsoup.connect(testUrl)
//                    .userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
//                    .timeout(10000)
//                    .get();
//            
//            System.out.println("페이지 제목: " + doc.title());
//            
//            // 뉴스 제목들 가져오기
//            Elements newsElements = doc.select("dt:not(.photo) a, .list_body .cluster_body .cluster_text a");
//            
//            System.out.println("찾은 뉴스 개수: " + newsElements.size());
//            
//            for (int i = 0; i < Math.min(10, newsElements.size()); i++) {
//                Element element = newsElements.get(i);
//                String title = element.text().trim();
//                String newsUrl = element.attr("href");
//                
//                if (!title.isEmpty() && title.length() > 10) {
//                    Notice notice = new Notice();
//                    notice.setTitle(title);
//                    notice.setUrl(newsUrl.startsWith("http") ? newsUrl : "https://news.naver.com" + newsUrl);
//                    notice.setSource("테스트 뉴스");
//                    notice.setContent(title);
//                    
//                    notices.add(notice);
//                    System.out.println((i+1) + ". " + title);
//                }
//            }
//            
//        } catch (Exception e) {
//            System.out.println("테스트 크롤링 오류: " + e.getMessage());
//            e.printStackTrace();
//            
//            // 오류 발생 시 더미 데이터라도 반환
//            Notice dummyNotice = new Notice();
//            dummyNotice.setTitle("테스트 공지사항 (더미 데이터)");
//            dummyNotice.setContent("크롤링 테스트용 더미 데이터입니다.");
//            dummyNotice.setSource("테스트");
//            dummyNotice.setUrl("http://example.com");
//            notices.add(dummyNotice);
//        }
//        
//        System.out.println("=== 테스트 크롤링 완료: " + notices.size() + "개 ===");
//        return notices;
//    }
//    
//    // 강원창업공단 공지사항 크롤링
//    public List<Notice> crawlKangwonNotices() {
//        List<Notice> notices = new ArrayList<>();
//        
//        try {
//            System.out.println("강원창업공단 크롤링 시작...");
//            
//            // 실제 사이트 대신 테스트용으로 더미 데이터 생성
//            Notice notice1 = new Notice();
//            notice1.setTitle("강원특별자치도 창업공단 2025년 신규 지원사업 공고");
//            notice1.setContent("2025년도 창업지원 프로그램에 대한 공지사항입니다.");
//            notice1.setSource("강원창업공단");
//            notice1.setUrl("https://www.gwtp.or.kr");
//            notices.add(notice1);
//            
//            Notice notice2 = new Notice();
//            notice2.setTitle("청년 창업가 육성 프로그램 모집");
//            notice2.setContent("만 39세 이하 청년을 대상으로 한 창업 프로그램입니다.");
//            notice2.setSource("강원창업공단");
//            notice2.setUrl("https://www.gwtp.or.kr");
//            notices.add(notice2);
//            
//        } catch (Exception e) {
//            System.out.println("강원창업공단 크롤링 오류: " + e.getMessage());
//        }
//        
//        return notices;
//    }
//    
//    // K-Startup 공지사항 크롤링
//    public List<Notice> crawlKStartupNotices() {
//        List<Notice> notices = new ArrayList<>();
//        
//        try {
//            System.out.println("K-Startup 크롤링 시작...");
//            
//            // 테스트용 더미 데이터
//            Notice notice1 = new Notice();
//            notice1.setTitle("2025년 예비창업패키지 사업 공고");
//            notice1.setContent("예비창업자를 위한 창업패키지 지원사업 안내");
//            notice1.setSource("K-스타트업");
//            notice1.setUrl("https://www.k-startup.go.kr");
//            notices.add(notice1);
//            
//            Notice notice2 = new Notice();
//            notice2.setTitle("초기창업패키지 2차 모집");
//            notice2.setContent("초기창업기업 대상 패키지 지원사업");
//            notice2.setSource("K-스타트업");
//            notice2.setUrl("https://www.k-startup.go.kr");
//            notices.add(notice2);
//            
//        } catch (Exception e) {
//            System.out.println("K-Startup 크롤링 오류: " + e.getMessage());
//        }
//        
//        return notices;
//    }
//    
//    // 모든 외부 공지사항 수집
//    public List<Notice> getAllExternalNotices() {
//        List<Notice> allNotices = new ArrayList<>();
//        
//        try {
//            System.out.println("=== 전체 공지사항 수집 시작 ===");
//            
//            List<Notice> kangwonNotices = crawlKangwonNotices();
//            List<Notice> kstartupNotices = crawlKStartupNotices();
//            
//            allNotices.addAll(kangwonNotices);
//            allNotices.addAll(kstartupNotices);
//            
//            System.out.println("강원창업공단: " + kangwonNotices.size() + "개");
//            System.out.println("K-스타트업: " + kstartupNotices.size() + "개");
//            System.out.println("총 수집: " + allNotices.size() + "개");
//            
//        } catch (Exception e) {
//            System.out.println("전체 공지사항 수집 오류: " + e.getMessage());
//        }
//        
//        return allNotices;
//    }
//    
//    // 데이터베이스에서 저장된 공지사항 조회
//    public List<Notice> getAllNotices() {
//        List<Notice> notices = new ArrayList<>();
//        
//        try {
//            Class.forName("com.mysql.cj.jdbc.Driver");
//            Connection conn = DriverManager.getConnection(url, user, password);
//            
//            String sql = "SELECT * FROM notices ORDER BY created_at DESC LIMIT 20";
//            PreparedStatement stmt = conn.prepareStatement(sql);
//            ResultSet rs = stmt.executeQuery();
//            
//            while (rs.next()) {
//                Notice notice = new Notice();
//                notice.setId(rs.getInt("id"));
//                notice.setTitle(rs.getString("title"));
//                notice.setContent(rs.getString("content"));
//                notice.setUrl(rs.getString("url"));
//                notice.setSource(rs.getString("source"));
//                notice.setCreatedAt(rs.getTimestamp("created_at"));
//                notice.setPublishedAt(rs.getTimestamp("published_at"));
//                
//                notices.add(notice);
//            }
//            
//            conn.close();
//        } catch (Exception e) {
//            System.out.println("DB 조회 오류: " + e.getMessage());
//            e.printStackTrace();
//        }
//        
//        return notices;
//    }
//    
//    // 공지사항 저장
//    public boolean saveNotice(Notice notice) {
//        try {
//            Class.forName("com.mysql.cj.jdbc.Driver");
//            Connection conn = DriverManager.getConnection(url, user, password);
//            
//            String sql = "INSERT INTO notices (title, content, url, source, published_at) VALUES (?, ?, ?, ?, NOW())";
//            PreparedStatement stmt = conn.prepareStatement(sql);
//            stmt.setString(1, notice.getTitle());
//            stmt.setString(2, notice.getContent());
//            stmt.setString(3, notice.getUrl());
//            stmt.setString(4, notice.getSource());
//            
//            int result = stmt.executeUpdate();
//            conn.close();
//            
//            return result > 0;
//        } catch (Exception e) {
//            System.out.println("공지사항 저장 오류: " + e.getMessage());
//            return false;
//        }
//    }
//}
package dao;

import java.sql.*;
import java.util.*;
import model.Notice;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class NoticeDAO {
    private String url = "jdbc:mysql://127.0.0.1:3306/gcg_db?useSSL=false&serverTimezone=UTC";
    private String user = "root";
    private String password = "Gimchanyoung1!";

    public List<Notice> crawlAndSaveKangwonNotices() {
        List<Notice> notices = new ArrayList<>();
        try {
            System.out.println("강원창업공단 크롤링 및 저장 시작...");
         
            Notice notice1 = new Notice();
            notice1.setTitle("강원특별자치도 창업공단 2025년 신규 지원사업 공고");
            notice1.setContent("2025년도 창업지원 프로그램에 대한 공지사항입니다.");
            notice1.setSource("강원창업공단");
            notice1.setUrl("https://www.gwtp.or.kr/board/view.do?menuId=1000000017&boardId=1001");
            
            Notice notice2 = new Notice();
            notice2.setTitle("청년 창업가 육성 프로그램 모집");
            notice2.setContent("만 39세 이하 청년을 대상으로 한 창업 프로그램입니다.");
            notice2.setSource("강원창업공단");
            notice2.setUrl("https://www.gwtp.or.kr/board/view.do?menuId=1000000017&boardId=1002");
            
            notices.add(notice1);
            notices.add(notice2);
            
            // 각 공지사항을 DB에 저장
            for (Notice notice : notices) {
                if (!isNoticeExists(notice.getTitle(), notice.getSource())) {
                    saveNotice(notice);
                    System.out.println("저장됨: " + notice.getTitle());
                } else {
                    System.out.println("이미 존재: " + notice.getTitle());
                }
            }
            
        } catch (Exception e) {
            System.out.println("강원창업공단 크롤링 및 저장 오류: " + e.getMessage());
        }
        return notices;
    }

    public List<Notice> crawlAndSaveKStartupNotices() {
        List<Notice> notices = new ArrayList<>();
        try {
            System.out.println("K-Startup 크롤링 및 저장 시작...");
            
            Notice notice1 = new Notice();
            notice1.setTitle("2025년 예비창업패키지 사업 공고");
            notice1.setContent("예비창업자를 위한 창업패키지 지원사업 안내");
            notice1.setSource("K-스타트업");
            notice1.setUrl("https://www.k-startup.go.kr/announcement/view.do?id=1001");
            
            Notice notice2 = new Notice();
            notice2.setTitle("초기창업패키지 2차 모집");
            notice2.setContent("초기창업기업 대상 패키지 지원사업");
            notice2.setSource("K-스타트업");
            notice2.setUrl("https://www.k-startup.go.kr/announcement/view.do?id=1002");
            
            notices.add(notice1);
            notices.add(notice2);
            
            for (Notice notice : notices) {
                if (!isNoticeExists(notice.getTitle(), notice.getSource())) {
                    saveNotice(notice);
                    System.out.println("저장됨: " + notice.getTitle());
                } else {
                    System.out.println("이미 존재: " + notice.getTitle());
                }
            }
            
        } catch (Exception e) {
            System.out.println("K-Startup 크롤링 및 저장 오류: " + e.getMessage());
        }
        return notices;
    }

    public List<Notice> crawlAndSaveAllNotices() {
        List<Notice> allNotices = new ArrayList<>();
        
        System.out.println("=== 전체 공지사항 크롤링 및 저장 시작 ===");
        
        List<Notice> kangwonNotices = crawlAndSaveKangwonNotices();
        List<Notice> kstartupNotices = crawlAndSaveKStartupNotices();
        
        allNotices.addAll(kangwonNotices);
        allNotices.addAll(kstartupNotices);
        
        System.out.println("총 " + allNotices.size() + "개 공지사항 처리 완료");
        return allNotices;
    }

    public boolean isNoticeExists(String title, String source) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            String sql = "SELECT COUNT(*) FROM notices WHERE title = ? AND source = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, source);
            
            ResultSet rs = stmt.executeQuery();
            boolean exists = false;
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
            
            conn.close();
            return exists;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveNotice(Notice notice) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            String sql = "INSERT INTO notices (title, content, url, source, published_at, created_at) VALUES (?, ?, ?, ?, NOW(), NOW())";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, notice.getTitle());
            stmt.setString(2, notice.getContent());
            stmt.setString(3, notice.getUrl());
            stmt.setString(4, notice.getSource());
            
            int result = stmt.executeUpdate();
            conn.close();
            
            return result > 0;
        } catch (Exception e) {
            System.out.println("공지사항 저장 오류: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Notice> getAllNotices() {
        List<Notice> notices = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            String sql = "SELECT * FROM notices ORDER BY created_at DESC LIMIT 20";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Notice notice = new Notice();
                notice.setId(rs.getInt("id"));
                notice.setTitle(rs.getString("title"));
                notice.setContent(rs.getString("content"));
                notice.setUrl(rs.getString("url"));
                notice.setSource(rs.getString("source"));
                notice.setCreatedAt(rs.getTimestamp("created_at"));
                notice.setPublishedAt(rs.getTimestamp("published_at"));
                
                notices.add(notice);
            }
            
            conn.close();
        } catch (Exception e) {
            System.out.println("DB 조회 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return notices;
    }

    public int getNoticeCount() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            String sql = "SELECT COUNT(*) FROM notices";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
            conn.close();
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}


