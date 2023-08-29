package com.easybytes.repository;

import com.easybytes.model.Notice;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NoticeRepository extends CrudRepository<Notice, Long> {

    @Query(value = "FROM Notice n WHERE CURDATE() BETWEEN noticBegDt AND noticEndDt") //jpql
    List<Notice> findAllActiveNotices();
}
