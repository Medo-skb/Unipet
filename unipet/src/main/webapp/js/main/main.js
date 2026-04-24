window.addEventListener("DOMContentLoaded", function () {
    const slides = document.querySelectorAll(".banner-slide");
    const dots = document.querySelectorAll(".banner-dot");
    const prevBtn = document.getElementById("prevBtn");
    const nextBtn = document.getElementById("nextBtn");
    const slider = document.getElementById("bannerSlider");

    if (!slides.length || !prevBtn || !nextBtn || !slider) {
        return;
    }

    let currentIndex = 0;
    let autoSlide = null;
    const slideCount = slides.length;
    const intervalTime = 3000;

    function showSlide(index) {
        slides.forEach(function (slide) {
            slide.classList.remove("active");
        });

        dots.forEach(function (dot) {
            dot.classList.remove("active");
        });

        slides[index].classList.add("active");
        dots[index].classList.add("active");
    }

    function nextSlide() {
        currentIndex++;

        if (currentIndex >= slideCount) {
            currentIndex = 0;
        }

        showSlide(currentIndex);
    }

    function prevSlide() {
        currentIndex--;

        if (currentIndex < 0) {
            currentIndex = slideCount - 1;
        }

        showSlide(currentIndex);
    }

    function startAutoSlide() {
        stopAutoSlide();

        autoSlide = setInterval(function () {
            nextSlide();
        }, intervalTime);
    }

    function stopAutoSlide() {
        if (autoSlide !== null) {
            clearInterval(autoSlide);
            autoSlide = null;
        }
    }

    nextBtn.addEventListener("click", function () {
        nextSlide();
        startAutoSlide();
    });

    prevBtn.addEventListener("click", function () {
        prevSlide();
        startAutoSlide();
    });

    dots.forEach(function (dot) {
        dot.addEventListener("click", function () {
            currentIndex = Number(this.dataset.index);
            showSlide(currentIndex);
            startAutoSlide();
        });
    });

    slider.addEventListener("mouseenter", function () {
        stopAutoSlide();
    });

    slider.addEventListener("mouseleave", function () {
        startAutoSlide();
    });

    showSlide(currentIndex);
    startAutoSlide();
});

window.addEventListener("DOMContentLoaded", function () {
    const fadeItems = document.querySelectorAll(".scroll-fade-up");

    if (!fadeItems.length) {
        return;
    }

    const observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add("show");
            }
        });
    }, {
        threshold: 0.15
    });

    fadeItems.forEach(function (item) {
        observer.observe(item);
    });
});