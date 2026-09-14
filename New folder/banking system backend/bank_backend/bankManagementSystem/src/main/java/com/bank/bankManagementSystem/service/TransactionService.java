package com.bank.bankManagementSystem.service;

import com.bank.bankManagementSystem.dto.TransactionRequest;
import com.bank.bankManagementSystem.dto.TransactionResponse;
import com.bank.bankManagementSystem.model.Account;
import com.bank.bankManagementSystem.model.Transaction;
import com.bank.bankManagementSystem.repository.AccountRepository;
import com.bank.bankManagementSystem.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final AccountRepository accountRepository;

    @Transactional
    public TransactionResponse processTransaction(TransactionRequest request) {
        Transaction transaction = new Transaction();
        transaction.setAmount(request.getAmount());
        transaction.setDescription(request.getDescription());
        transaction.setType(Transaction.TransactionType.valueOf(request.getType().toUpperCase(Locale.ROOT)));

        switch (transaction.getType()) {
            case DEPOSIT -> {
                Account toAccount = getActiveAccount(request.getToAccountNumber());
                toAccount.setBalance(toAccount.getBalance().add(request.getAmount()));
                accountRepository.save(toAccount);
                transaction.setToAccount(toAccount);
            }
            case WITHDRAWAL -> {
                Account fromAccount = getActiveAccount(request.getFromAccountNumber());
                if (fromAccount.getBalance().compareTo(request.getAmount()) < 0)
                    throw new RuntimeException("Insufficient funds");
                fromAccount.setBalance(fromAccount.getBalance().subtract(request.getAmount()));
                accountRepository.save(fromAccount);
                transaction.setFromAccount(fromAccount);
            }
            case TRANSFER -> {
                Account fromAccount = getActiveAccount(request.getFromAccountNumber());
                Account toAccount = getActiveAccount(request.getToAccountNumber());
                if (fromAccount.getBalance().compareTo(request.getAmount()) < 0)
                    throw new RuntimeException("Insufficient funds");
                fromAccount.setBalance(fromAccount.getBalance().subtract(request.getAmount()));
                toAccount.setBalance(toAccount.getBalance().add(request.getAmount()));
                accountRepository.save(fromAccount);
                accountRepository.save(toAccount);
                transaction.setFromAccount(fromAccount);
                transaction.setToAccount(toAccount);
            }
        }

        return mapToResponse(transactionRepository.save(transaction));
    }

    public List<TransactionResponse> getTransactionHistory(Long accountId) {
        return transactionRepository.findAllByAccountId(accountId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    private Account getActiveAccount(String accountNumber) {
        Account account = accountRepository.findByAccountNumber(accountNumber)
                .orElseThrow(() -> new RuntimeException("Account not found: " + accountNumber));
        if (account.getStatus() != Account.AccountStatus.ACTIVE)
            throw new RuntimeException("Account is not active: " + accountNumber);
        return account;
    }

    private TransactionResponse mapToResponse(Transaction t) {
        TransactionResponse response = new TransactionResponse();
        response.setId(t.getId());
        response.setType(t.getType().name());
        response.setAmount(t.getAmount());
        response.setDescription(t.getDescription());
        response.setStatus(t.getStatus().name());
        response.setCreatedAt(t.getCreatedAt());
        if (t.getFromAccount() != null)
            response.setFromAccountNumber(t.getFromAccount().getAccountNumber());
        if (t.getToAccount() != null)
            response.setToAccountNumber(t.getToAccount().getAccountNumber());
        return response;
    }
}
