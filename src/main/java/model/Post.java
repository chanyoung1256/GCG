package model;

public class Post {
    private int id;
    private int userId;
    private String title;
    private String content;
    private String address;
    private String imagePath;
    private String createdAt;

    public Post() {
    }

    public Post(int userId, String title, String content, String address, String imagePath, String createdAt) {
        this.userId = userId;
        this.title = title;
        this.content = content;
        this.address = address;
        this.imagePath = imagePath;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public int getUserId() {
        return userId;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getAddress() {
        return address;
    }

    public String getImagePath() {
        return imagePath;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    // Setter 메서드들
    public void setId(int id) {
        this.id = id;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Post{" +
                "id=" + id +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", address='" + address + '\'' +
                ", imagePath='" + imagePath + '\'' +
                ", createdAt='" + createdAt + '\'' +
                '}';
    }
}

