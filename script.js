searchForm=document.querySelector('.search-form');

document.querySelector('#search-btn').onclick = () =>{
    searchForm.classList.toggle('active');
}

window.onscroll=() =>{

    searchForm.classList.remove('active');

    if(window.scrollY>80){
        document.querySelector('.header .header-2').classList.add('active');
    }
    else{
        document.querySelector('.header .header-2').classList.remove('active');
    }
}

window.onscroll=() =>{
    if(window.scrollY>80){
        document.querySelector('.header .header-2').classList.add('active');
    }
    else{
        document.querySelector('.header .header-2').classList.remove('active');
    }
}

let loginForm=document.querySelector('.login-form-container');

document.querySelector('#login-btn').onclick=() =>{
    loginForm.classList.toggle('active');
}

document.querySelector('#close-login-btn').onclick=() =>{
    loginForm.classList.toggle('active');
}

document.addEventListener("DOMContentLoaded", function () {
    let wishlist = JSON.parse(localStorage.getItem("wishlist")) || [];

    document.querySelectorAll(".wishlist-icon").forEach(icon => {
        const bookTitle = icon.dataset.title;

        if (wishlist.includes(bookTitle)) {
            icon.classList.add("active");
        }

        icon.addEventListener("click", function (event) {
            event.preventDefault();
            if (wishlist.includes(bookTitle)) {
                wishlist = wishlist.filter(item => item !== bookTitle);
                this.classList.remove("active");
            } else {
                wishlist.push(bookTitle);
                this.classList.add("active");
            }

            localStorage.setItem("wishlist", JSON.stringify(wishlist));
        });
    });
});

document.addEventListener("DOMContentLoaded", function () {
    let cart = JSON.parse(localStorage.getItem("cart")) || [];

    document.querySelectorAll(".cart-btn").forEach(button => {
        const bookTitle = button.dataset.title;
        const bookPrice = button.dataset.price;

        button.addEventListener("click", function () {
            let existingBook = cart.find(item => item.title === bookTitle);

            if (existingBook) {
                existingBook.quantity += 1;
            } else {
                cart.push({ title: bookTitle, price: bookPrice, quantity: 1 });
            }

            localStorage.setItem("cart", JSON.stringify(cart));
            alert(`${bookTitle} added to cart!`);
        });
    });
});