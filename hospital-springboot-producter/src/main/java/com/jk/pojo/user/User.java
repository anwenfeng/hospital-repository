package com.jk.pojo.user;

import java.io.Serializable;

public class User implements Serializable{

    private static final long serialVersionUID = -668166411836811415L;

    private Integer userId;

    private  String userName;


    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getUserId() {

        return userId;
    }

    public String getUserName() {
        return userName;
    }
}
