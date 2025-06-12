package model;

import java.sql.Timestamp;

public class Notice {
    private int id;
    private String title;
    private String content;
    private String url;
    private String source; 
    private Timestamp createdAt;
    private Timestamp publishedAt;
   
    public Notice() {}
    
   
    public Notice(String title, String content, String url, String source, Timestamp publishedAt) {
        this.title = title;
        this.content = content;
        this.url = url;
        this.source = source;
        this.publishedAt = publishedAt;
    }


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}


	public String getContent() {
		return content;
	}


	public void setContent(String content) {
		this.content = content;
	}


	public String getUrl() {
		return url;
	}


	public void setUrl(String url) {
		this.url = url;
	}


	public String getSource() {
		return source;
	}


	public void setSource(String source) {
		this.source = source;
	}


	public Timestamp getCreatedAt() {
		return createdAt;
	}


	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}


	public Timestamp getPublishedAt() {
		return publishedAt;
	}


	public void setPublishedAt(Timestamp publishedAt) {
		this.publishedAt = publishedAt;
	}
    
}
