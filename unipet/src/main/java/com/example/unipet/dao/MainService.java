package com.example.unipet.dao;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.unipet.mapper.MainMapper;
import com.example.unipet.model.Main;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MainService {

    private final MainMapper mainMapper;

    public Main getMainBasicData() {

        List<Main> popularStoreList = mainMapper.selectPopularStoreList();
        List<Main> popularProductList = mainMapper.selectPopularProductList();

        Main main = new Main();
        main.setPopularStoreList(popularStoreList);
        main.setPopularProductList(popularProductList);

        return main;
    }
}