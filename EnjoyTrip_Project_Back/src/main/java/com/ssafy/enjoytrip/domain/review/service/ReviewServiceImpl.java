package com.ssafy.enjoytrip.domain.review.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.enjoytrip.S3ImageService;
import com.ssafy.enjoytrip.domain.review.dto.ReviewDto;
import com.ssafy.enjoytrip.domain.review.entity.ReviewEntity;
import com.ssafy.enjoytrip.domain.review.mapper.ReviewMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

	private final ReviewMapper reviewMapper;
	private final S3ImageService s3ImageService;

	@Override
	public List<ReviewEntity> getReviewList(Integer content_id) throws Exception {

		try {
			List<ReviewEntity> reviewList = reviewMapper.getReviewList(content_id);
			for (ReviewEntity review : reviewList) {
				List<ReviewDto.ReviewFileInfo> fileInfoList = reviewMapper.fileInfoList(review.getReviewId());
				review.setFileInfo(fileInfoList);
			}
			return reviewList;

		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public void registReview(ReviewDto.Regist regist, MultipartFile[] files) throws Exception {

		log.info("============================리뷰 등록 서비스 임플 ======================");

		List<ReviewDto.ReviewFileInfo> fileInfos = new ArrayList<>();

		if (files != null && !files[0].isEmpty()) {
			for (MultipartFile mfile : files) {
				ReviewDto.ReviewFileInfo fileInfoDto = ReviewDto.ReviewFileInfo.builder().build();

				String originalFileName = mfile.getOriginalFilename();
				String profileImage = s3ImageService.upload(mfile);

				fileInfoDto.setOriginalFile(originalFileName);
				fileInfoDto.setImgUrl(profileImage);

				fileInfos.add(fileInfoDto);
			}
			regist.setFileInfos(fileInfos);
		}


		try {
			reviewMapper.registReview(regist);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}

		if (fileInfos != null && !fileInfos.isEmpty()) {
			try {
				reviewMapper.registerFile(regist);
			} catch (Exception e) {
				e.printStackTrace();
				throw new RuntimeException(e);
			}
		}
	}

	@Override
	public List<ReviewDto.ReviewFileInfo> fileInfoList(int reviewId) throws Exception {
		return reviewMapper.fileInfoList(reviewId);
	}

	@Override
	public void modifyReview(ReviewDto.Update update) throws Exception {
		reviewMapper.modifyReview(update);
	}

	@Override
	public void deleteReview(ReviewDto.Delete delete) throws Exception {
		reviewMapper.deleteReview(delete);
	}
}
