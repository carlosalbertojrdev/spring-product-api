package dev.carlosalbertojr.productapi.dto;

import dev.carlosalbertojr.productapi.entity.Product;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

public record CreateProductRequestDto(
    @NotEmpty String name, 
    @NotEmpty String description,
    @NotNull Double price) {

    public Product toProduct() {
        return new Product(name, description, price);
    }
}
