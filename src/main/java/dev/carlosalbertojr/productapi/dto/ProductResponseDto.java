package dev.carlosalbertojr.productapi.dto;

import dev.carlosalbertojr.productapi.entity.Product;

public record ProductResponseDto(String id, String name, String description, Double price) {

    public ProductResponseDto(Product product) {
        this(product.getId(), product.getName(), product.getDescription(), product.getPrice());
    }
}
