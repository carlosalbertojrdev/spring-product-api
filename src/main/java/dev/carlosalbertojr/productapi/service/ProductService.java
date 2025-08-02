package dev.carlosalbertojr.productapi.service;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import dev.carlosalbertojr.productapi.entity.Product;
import dev.carlosalbertojr.productapi.repository.ProductRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;

    @Cacheable(value = "findAllProducts", key = "#page + '-' + #size")
    public List<Product> getAllProducts(Integer page, Integer size) {
        return productRepository.findAll(PageRequest.of(page, size))
        .getContent();
    }

    public Product createProduct(Product product) {
        return productRepository.save(product);
    }

}
