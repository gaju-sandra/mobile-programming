package com.bank.bankManagementSystem.service;

import com.bank.bankManagementSystem.model.Account;
import com.bank.bankManagementSystem.model.User;
import com.bank.bankManagementSystem.repository.AccountRepository;
import com.bank.bankManagementSystem.repository.UserRepository;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.List;
import java.util.Locale;

@Service
public class AccountService {

    private final AccountRepository accountRepository;
    private final UserRepository userRepository;
    private final SecureRandom secureRandom = new SecureRandom();

    public AccountService(AccountRepository accountRepository, UserRepository userRepository) {
        this.accountRepository = accountRepository;
        this.userRepository = userRepository;
    }

    public Account createAccount(String accountType) {
        User user = getLoggedInUser();

        Account account = new Account();
        account.setUser(user);
        account.setAccountType(Account.AccountType.valueOf(accountType.toUpperCase(Locale.ROOT)));
        account.setAccountNumber(generateAccountNumber());

        return accountRepository.save(account);
    }

    public List<Account> getMyAccounts() {
        return accountRepository.findByUserId(getLoggedInUser().getId());
    }

    public Account getAccountByNumber(String accountNumber) {
        return accountRepository.findByAccountNumber(accountNumber)
                .orElseThrow(() -> new RuntimeException("Account not found"));
    }

    private User getLoggedInUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    private String generateAccountNumber() {
        String number;
        do {
            number = "ACC-" + String.format(Locale.ROOT, "%09d", (long) (secureRandom.nextDouble() * 1_000_000_000));
        } while (accountRepository.existsByAccountNumber(number));
        return number;
    }
}
