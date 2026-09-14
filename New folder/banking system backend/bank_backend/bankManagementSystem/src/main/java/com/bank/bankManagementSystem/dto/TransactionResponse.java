package com.bank.bankManagementSystem.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class TransactionResponse {
    private Long id;
    private String type;
    private BigDecimal amount;
    private String description;
    private String status;
    private String fromAccountNumber;
    private String toAccountNumber;
    private LocalDateTime createdAt;
}
