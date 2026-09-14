package com.bank.bankManagementSystem.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "transactions")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TransactionType type;

    @Column(nullable = false)
    private BigDecimal amount;

    private String description;

    @Enumerated(EnumType.STRING)
    private TransactionStatus status = TransactionStatus.SUCCESS;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @JsonIgnoreProperties({"transactions", "user"})
    @ManyToOne
    @JoinColumn(name = "from_account_id")
    private Account fromAccount;

    @JsonIgnoreProperties({"transactions", "user"})
    @ManyToOne
    @JoinColumn(name = "to_account_id")
    private Account toAccount;

    public enum TransactionType {
        DEPOSIT, WITHDRAWAL, TRANSFER
    }

    public enum TransactionStatus {
        SUCCESS, FAILED
    }
}
