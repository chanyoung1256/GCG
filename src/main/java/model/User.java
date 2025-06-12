//package model;
//
//import java.sql.Timestamp;
//
//public class User {
//	private int id;
//	private String username;
//	private String password;
//	private Timestamp createdAt;
//
//	public User() {}
//
//	public User(String username, String password) {
//		this.username = username;
//		this.password = password;
//	}
//
//	// 전체 생성자 (id까지)
//	public User(int id, String username, String password, Timestamp createdAt) {
//		this.id = id;
//		this.username = username;
//		this.password = password;
//		this.createdAt = createdAt;
//	}
//
//	public int getId() {
//		return id;
//	}
//	public void setId(int id) {
//		this.id = id;
//	}
//	public String getUsername() {
//		return username;
//	}
//	public void setUsername(String username) {
//		this.username = username;
//	}
//	public String getPassword() {
//		return password;
//	}
//	public void setPassword(String password) {
//		this.password = password;
//	}
//	public Timestamp getCreatedAt() {
//		return createdAt;
//	}
//	public void setCreatedAt(Timestamp createdAt) {
//		this.createdAt = createdAt;
//	}
//}

package model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private boolean isAdmin;
    private Timestamp createdAt;

    public User() {}

    public User(String username, String password, String email) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.isAdmin = false;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", isAdmin=" + isAdmin +
                ", createdAt=" + createdAt +
                '}';
    }
}
