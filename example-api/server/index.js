const express = require('express');
const app = express();
const mysql = require('mysql2');
const cors = require('cors')

app.use(express.json());
app.use(cors());

const connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : 'test123*',
  database : "examples"
});

connection.connect(function(err) {
    if (err) {
        console.error('error connecting: ' + err.stack);
        return;
    }

    console.log('connected as id ' + connection.threadId);
});

app.get('/articles-with-comments', function (req, res) {
    const result = {};

    if (req.query.type === 'inner') {
        connection.query("SELECT articles.id AS articleId,articles.content AS articleContent,articles.title AS articleTitle,comments.id AS commentId,comments.content AS commentContent FROM articles INNER JOIN comments ON articles.id=comments.article_id",(err,sqlRes,fields) => {
            for (const row of sqlRes) {
                if (!result[row.articleId]) {
                    result[row.articleId] = {
                        articleId : row.articleId,
                        articleTitle : row.articleTitle,
                        articleContent : row.articleContent,
                        comments : []
                    }
                }
                if (row.commentId) {
                    result[row.articleId].comments.push({
                        commentId : row.commentId,
                        commentContent : row.commentContent
                    });
                }
            }
            res.json(Object.values(result));
        });
    }else if (req.query.type === 'left') {
        connection.query("SELECT articles.id AS articleId,articles.content AS articleContent,articles.title AS articleTitle,comments.id AS commentId,comments.content AS commentContent FROM articles LEFT JOIN comments ON articles.id=comments.article_id",(err,sqlRes,fields) => {
            for (const row of sqlRes) {
                if (!result[row.articleId]) {
                    result[row.articleId] = {
                        articleId : row.articleId,
                        articleTitle : row.articleTitle,
                        articleContent : row.articleContent,
                        comments : []
                    }
                }
                if (row.commentId) {
                    result[row.articleId].comments.push({
                        commentId : row.commentId,
                        commentContent : row.commentContent
                    });
                }
            }
            res.json(Object.values(result));
        });
    }else if (req.query.type === 'right') {
        connection.query("SELECT articles.id AS articleId,articles.content AS articleContent,articles.title AS articleTitle,comments.id AS commentId,comments.content AS commentContent FROM articles RIGHT JOIN comments ON articles.id=comments.article_id",(err,sqlRes,fields) => {
            for (const row of sqlRes) {
                if (!result[row.articleId]) {
                    result[row.articleId] = {
                        articleId : row.articleId,
                        articleTitle : row.articleTitle,
                        articleContent : row.articleContent,
                        comments : []
                    }
                }
                if (row.commentId) {
                    result[row.articleId].comments.push({
                        commentId : row.commentId,
                        commentContent : row.commentContent
                    });
                }
            }
            res.json(Object.values(result));
        });
    }else{
        res.sendStatus(400);
    }
})

app.listen(8001,() => {
    console.log("listening")
});