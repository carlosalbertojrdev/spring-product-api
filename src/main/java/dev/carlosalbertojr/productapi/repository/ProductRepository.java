package dev.carlosalbertojr.productapi.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import dev.carlosalbertojr.productapi.entity.Product;

public interface ProductRepository extends JpaRepository<Product, String> {   
}
