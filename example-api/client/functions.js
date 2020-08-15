
function createArticleDiv(article) {
    const contentDiv = document.createElement("div");
    const title = document.createElement("h2");
    const textDiv = document.createElement("p");
    const commentsDiv = document.createElement("div");
    const commentsTitle = document.createElement("h3");
    commentsTitle.innerText = "Commentaires";

    title.innerText = article.articleTitle;
    textDiv.innerText = article.articleContent;

    contentDiv.appendChild(title);
    contentDiv.appendChild(textDiv);
    contentDiv.appendChild(commentsTitle);

    for (const comment of article.comments) {
        contentDiv.appendChild(
            createCommentDiv(comment)
        );
    }

    return contentDiv;
}


function createCommentDiv(comment) {
    const contentDiv = document.createElement("div");
    const textDiv = document.createElement("p");
    textDiv.innerText = comment.commentContent;
    contentDiv.appendChild(textDiv);
    return contentDiv;
}

async function getArticleWithComments(type) {
    let result = await fetch(`http://localhost:8001/articles-with-comments?type=${type}`);
    const json = await result.json();
    const mainDiv = document.querySelector("main");

    const articleHeading = document.querySelector("h1");

    articleHeading.innerText = `Mes articles (${json.length})`;
    
    mainDiv.innerHTML = '';

    for (const article of json) {
        mainDiv.appendChild(createArticleDiv(article));
    }
}