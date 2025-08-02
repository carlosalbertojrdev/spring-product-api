package dev.carlosalbertojr.productapi.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import dev.carlosalbertojr.productapi.dto.CreateProductRequestDto;
import dev.carlosalbertojr.productapi.dto.ProductResponseDto;
import dev.carlosalbertojr.productapi.service.ProductService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping
    public List<ProductResponseDto> getAllProducts(@RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return productService.getAllProducts(page, size)
                .stream()
                .map(ProductResponseDto::new)
                .toList();
    }

    @PostMapping
    public ProductResponseDto createProduct(@RequestBody CreateProductRequestDto request) {
        return new ProductResponseDto(productService.createProduct(request.toProduct()));
    }

}
