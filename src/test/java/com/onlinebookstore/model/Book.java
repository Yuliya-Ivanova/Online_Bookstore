package com.onlinebookstore.model;

import com.google.gson.annotations.SerializedName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * POJO class representing a Book entity
 * Uses Lombok to reduce boilerplate code
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Book {
    
    @SerializedName("id")
    private Integer id;
    
    @SerializedName("title")
    private String title;
    
    @SerializedName("description")
    private String description;
    
    @SerializedName("excerpt")
    private String excerpt;
    
    @SerializedName("pageCount")
    private Object pageCount;
    
    @SerializedName("publishDate")
    private String publishDate;

    public Book(String title, String description, String excerpt, Object pageCount, String publishDate) {
        this.title = title;
        this.description = description;
        this.excerpt = excerpt;
        this.pageCount = pageCount;
        this.publishDate = publishDate;
    }
} 