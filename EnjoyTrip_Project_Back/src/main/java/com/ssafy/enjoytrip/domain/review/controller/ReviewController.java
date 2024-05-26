package com.ssafy.enjoytrip.domain.review.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.enjoytrip.S3ImageService;
import com.ssafy.enjoytrip.domain.member.entity.MemberEntity;
import com.ssafy.enjoytrip.domain.review.dto.ReviewDto;
import com.ssafy.enjoytrip.domain.review.entity.ReviewEntity;
import com.ssafy.enjoytrip.domain.review.service.ReviewService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequiredArgsConstructor
public class ReviewController {

	private final ReviewService reviewService;
	private final S3ImageService s3ImageService;

	@GetMapping("/review/{content_id}")
	public ResponseEntity<List<ReviewEntity>> getReviewList(@PathVariable("content_id") Integer contentId) {

		log.info("=======================리뷰 조회========================");
		log.info("getReviewList : {}", contentId);

		try {
			List<ReviewEntity> reviewList = reviewService.getReviewList(contentId);
			return new ResponseEntity<>(reviewList, HttpStatus.OK);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	@PostMapping("/review")
	public ResponseEntity<ReviewEntity> registReview(
		ReviewDto.Regist regist,
		@RequestParam(value = "upfile", required = false) MultipartFile[] files,
		HttpSession session) throws IOException {

		String userId = ((MemberEntity)session.getAttribute("memberDto")).getUserId();
		regist.setUserId(userId);

		try {
			reviewService.registReview(regist, files);
			return new ResponseEntity<>(HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@DeleteMapping("/review")
	public ResponseEntity<Void> deleteReview(ReviewDto.Delete delete) {

		log.info("================={}=============", delete.getUserId());
		log.info("================={}=============", delete.getReviewId());

		try {
			reviewService.deleteReview(delete);
			return new ResponseEntity<>(HttpStatus.OK);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	// TODO : 유저검증과 content_id 검증 하는 로직 들어가야함
	@PutMapping("/review")
	public ResponseEntity<Void> modifyReview(ReviewDto.Update update) {

		log.info("==========================={}=========================", update);

		try {
			reviewService.modifyReview(update);
			return new ResponseEntity<>(HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}

	}
}
