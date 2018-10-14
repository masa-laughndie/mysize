//escape
function escapeHtml(string) {
  if (typeof string !== "string") {
    return string;
  }

  return string.replace(/[&'`"<>=\/]/g, function(match) {
    return {
      "&": "&amp;",
      "'": "&#x39;",
      "`": "&#x60;",
      '"': "&quot;",
      "/": "&#x2F;",
      "<": "&lt;",
      ">": "&gt;",
      "=": "&#x3D;"
    }[match];
  });
}

//flash表示非表示
$(function() {
  if ($("#flash").length != 0) {
    $("#flash")
      .css("display", "none")
      .slideDown("fast"); //slideさせるために一旦非表示
    setTimeout(function() {
      $("#flash").slideUp("fast");
    }, 3000);
  }
});

//post-menuスライドバー
// $(function() {
//   //comment-menu
//   $("[id^=post-nav-comment]").on("click", function() {
//     var str = $(this).attr("id"),
//       num = str.match(/\d/g).join("");
//     $("#nav-list-comment-" + num).slideToggle("fast");
//   });

//   //kickspost-menu
//   $("[id^=post-nav-kickspost]").on("click", function() {
//     var str = $(this).attr("id"),
//       num = str.match(/\d/g).join("");
//     $("#nav-list-kickspost-" + num).slideToggle("fast");
//   });
// });

function setReply(_this) {
  var cid = _this.attr("id"),
    comID = cid.match(/\d/g).join(""), //comment.id
    forIDs = $("#content-name-" + comID).text(), //返信先の親@IDを取得(返信相手全@ID配列)
    comLink = $("#comment-" + comID).find(".id-link"), //親の返信相手オブジェクト
    myID = "@" + $("#my-icon").attr("alt"), //自分の@ID
    rclass = $("#comment-" + comID).attr("class"),
    replyID = rclass.match(/\d/g).join(""); //返信先のcomment.reply_id

  //返信先がコメント
  if (replyID == 0) {
    $("#reply-id").attr("value", comID);
    //それ以外(返信先がリプライ)
  } else {
    $("#reply-id").attr("value", replyID);
  }

  //親の返信相手がいる
  if (comLink.length != 0) {
    var parentID = forIDs; //親@iD複製(forIDs更新のため)

    comLink.each(function() {
      var rid = $(this).text(); //  返信相手の@ID
      //@IDが親と自分と違う場合
      if (rid != parentID && rid != myID) {
        forIDs = forIDs + " " + $(this).text();
      }
    });
  }
  $(".comment-text-form").val(forIDs + " ");
  $(".comment-text-form").focus();
}

//comment返信(reply_idの設定,自動focus)
$(function() {
  //同じ要素内でautolink化しているためclick発火には静的な親要素で仕込む必要あり
  $("body").on("click", "[id^=comment-reply]", function() {
    if ($(".comment-text-form").length != 0) {
      setReply($(this));
    }
    return false;
  });
});

//ポスト内容の改行挿入
$(function() {
  $(".post-text").each(function() {
    var txt = escapeHtml($(this).text());
    txt = txt.replace(/\r\n|\r/g, "\n").replace(/\n/g, "<br>");
    $(this).html(txt);
  });
});

//reply_idチェック(@IDがない場合 => reply_id:　0　に変える)

$(function() {
  $("#comment-button").on("click", function() {
    var content = $("#comment_content").val(),
      uid = content.match(/@[a-zA-Z0-9_]+\s/g);
    if (uid == null) {
      $("#reply-id").attr("value", 0);
    }
  });
});

//コメントフォーム自動拡張&格納

$(function() {
  $(".comment-text-form")
    .focus(function() {
      $(".comment-form").css("height", "181px");
      return false;
    })
    .blur(function() {
      $(".comment-form").css("height", "71px");
      return false;
    });
});

//mysize_is表読み込み
function indexId() {
  return $.ajax({
    type: "GET",
    url: "/index?for=mysizeid&key=mysizeid",
    dataType: "html",
    timeout: 20000
  });
}

//@IDのリンク化
function changeLink(_iid) {
  $(".autolink").each(function() {
    var txt = $(this).html(),
      exp = txt.match(/@[a-zA-Z0-9_]+?(\s|<br>|<\/span>)/g); //全「@ID(空白|<br>|</span>)」
    exp = Array.from(new Set(exp)); //重複削除
    if (exp != null) {
      for (var i = 0; i < exp.length; i++) {
        var elength = exp[i].length, //文字数
          msid = exp[i].replace(/@|\s|<br>|<\/span>/g, ""); //「ID」
        //indexid内のものと一致する場合リンク化
        if (iid.indexOf(msid) >= 0) {
          var url =
              window.location.protocol +
              "//" +
              window.location.host +
              "/" +
              msid, //リンクURL
            str = exp[i].replace(/\s|<br>|<\/span>/g, ""), //「@ID」
            option = exp[i].replace(str, ""), //msidの後続
            txt = $(this).html(), //新たに定義しないと複数置換できない
            //new RegExp(exp[i], 'g')で重複を一括replace
            //exp[i]は重複(=完全一致)以外は一意の文字列のため、exp[i]でreplaceして削られるoptionを後から追加
            replaceText = txt.replace(
              new RegExp(exp[i], "g"),
              "<a class='id-link' href=" +
                escapeHtml(url) +
                ">" +
                escapeHtml(str) +
                "</a>" +
                option
            );
          $(this).html(replaceText);
        }
      }
    }
  });
}

//index_id
iid = [];

//comment送信先ユーザーリンク化
$(function() {
  if ($(".autolink").length != 0) {
    //data未取得
    if (iid.length == 0) {
      indexId()
        .done(function(data) {
          iid = $(data)
            .find("#index-id")
            .text()
            .split(/\s+/);
          iid.shift();
          iid.pop();
          changeLink(iid);
        })
        .fail(function(data) {
          alert(
            "ページの読み込みに失敗しました。電波の良い場所で再度読み込んでください。"
          );
          return false;
        });
      //data取得済み
    } else {
      changeLink(iid);
    }
  }
});

//indexリンクの高さ自動調整
$(function() {
  $(".link-list").each(function() {
    //子要素(=absolute要素内の固定長要素)の高さ
    var height = $(this)
      .find(".content-height")
      .height();
    $(this).height(height);
    $(this)
      .find(".content-link")
      .css("padding-bottom", height);
  });
});

//現在位置ボタンの色変換(active化)
$(function() {
  $(".alist").each(function() {
    var fullPath = location.pathname + location.search,
      link = $(this).find("a"),
      linkPath = link.attr("href");
    if (fullPath == linkPath) {
      link.addClass("active");
    }
  });
});

//未ログインアラートボタン
$(function() {
  $(".ban").on("click", function() {
    alert("登録またはログインしてください！");
    return false;
  });
});

//画像ファイルプレビュー
$(function() {
  //from内の該当要素を選択されたら(ファイルを選択しないときは発火しない)
  $("form").on("change", 'input[type="file"]', function(e) {
    var file = e.target.files[0], //ファイルオブジェクト
      reader = new FileReader(),
      $preview = $(".preview");

    //実効終了条件
    if (file == undefined || file.type.indexOf("image") < 0) {
      return false;
    }

    //読み込み成功して完了(onload)
    reader.onload = (function(file) {
      return function(e) {
        //preview挿入
        $preview.empty();
        $preview.append(
          $("<img>").attr({
            src: e.target.result,
            width: "35%",
            class: "cover",
            title: file.name
          })
        );
        //icon変更
        $(".upload-icon").empty();
        $(".upload-icon").append($("<i>").attr("class", "fa fa-refresh"));
      };
    })(file);
    //ファイルをURLとして読み込む
    reader.readAsDataURL(file);
  });
});

//textareaの高さ自動変更(要縮小対応)
$(function() {
  if ($(".autoheight").length != 0) {
    var maxHeight = $(".autoheight")
      .css("maxHeight")
      .split("px")[0];
    $(".autoheight").on("keyup", function(e) {
      var $textarea = $(e.target),
        allHeight = e.target.scrollHeight, //スクロールを含めた全体の高さ
        areaHeight = e.target.offsetHeight; //要素(textarea)の高さ

      if (allHeight < maxHeight && allHeight > areaHeight) {
        $textarea.height(allHeight);
      }
    });
  }
});

//ハッシュタグのリンク化
$(function() {
  $(".autolink").each(function() {
    var txt = $(this).html(),
      exp = txt.match(/#\S+?(\s|<br>)/g), //全「#(任意の文字列)(空白or<br>」
      exp = Array.from(new Set(exp)); //重複削除
    if (exp != null) {
      for (var i = 0; i < exp.length; i++) {
        var elength = exp[i].length,
          word = exp[i].replace(/\s|<br>|<\/span>|<\/a>/g, ""), //「#(任意の文字列)」
          option = exp[i].replace(word, ""), //wordの後続
          key = "%23" + word.slice(1), //「#」削除
          url = "/search?for=post&keyword=" + key, //リンクURL
          txt = $(this).html(); //新たに定義しないと複数置換できない

        //new RegExp(exp[i], 'g')で重複を一括replace
        //exp[i]は重複(=完全一致)以外は一意の文字列のため、exp[i]でreplaceして削られるoptionを後から追加
        var replaceText = txt.replace(
          new RegExp(exp[i], "g"),
          "<a class='tag-link' href=" +
            escapeHtml(url) +
            ">" +
            escapeHtml(word) +
            "</a>" +
            option
        );
        $(this).html(replaceText);
      }
    }
  });
});

//アンカーポイントへジャンプ
function jumpScroll(_this, _point, time) {
  var target = $(_point == "#" || _point == "" ? $("html") : _point);
  if (target.length == 0) target = $("html");
  var position = target.offset().top,
    move = _this.data("scroll"); //header考慮した加算量
  //data-scroll属性あり
  if (move !== undefined) position = position + Number(move);
  //Android対応処理
  if (position <= 0) position = 1;

  $("html, body").animate({ scrollTop: position }, Number(time), "swing");
}

//ページ遷移 or アンカーポイントへジャンプ
$(function() {
  $("body").on("click", ".jump", function(e) {
    var _this = $(this);
    (link = _this.attr("href")), //アンカーリンク先
      (index = link.indexOf("#")),
      (point = link.slice(index)), //link先のlocation.hash
      (linkPath = link.replace(point, "")), //リンク先のpathname
      (nowPath = window.location.pathname);

    //遷移先にいない
    if (linkPath != nowPath) {
      window.location.href = linkPath + escapeHtml(point);
      return false;
    }

    //遷移先にいる(comment用)
    if (point.match(/#comment/) != null) {
      e.preventDefault();
      jumpScroll(_this, point, 500);
      return false;
    }

    //遷移先にいる(about用)
    if (point.match(/#about/) != null) {
      e.preventDefault();
      jumpScroll(_this, point, 1000);
      return false;
    }
  });
});

//アンカーポイントへジャンプ(kickspost)
$(function() {
  if (
    $(".jump").length != 0 &&
    window.location.pathname.match(/kicksposts/) != null
  ) {
    var _hash = escapeHtml(window.location.hash),
      _comment = $(".post-main").find(_hash); //対象comment

    //対象存在確認
    if (_hash !== "" && _comment.length != 0) {
      _comment.css("background", "rgba(255, 0, 0, 0.05)");
      jumpScroll($(".jump"), _hash, 500);
      $("#reply-active")
        .find("a")
        .addClass("active");

      //他ページからのreplyボタンでの遷移
      if (window.location.search == "?reply=on") {
        setTimeout(function() {
          setReply(_comment); //スクロール後にsetReply
        }, 510);
      }
    }
  }
  return false;
});

//アンカーポイントへジャンプ(about)
$(function() {
  if (
    $(".jump").length != 0 &&
    window.location.pathname.match(/about/) != null
  ) {
    var _hash = escapeHtml(window.location.hash), //URLの「#~」
      target = $(".about-main").find(_hash); //対象comment

    if (_hash !== "" && target.length != 0) {
      jumpScroll($(".jump"), _hash, 1000);
    }
  }
});

//スクロール位置での表示非表示
function scrollOut(_target, _point) {
  $(window).scroll(function() {
    var distance = $(window).scrollTop();
    if (_point >= distance) {
      _target.fadeIn();
    } else if (_point <= distance) {
      _target.fadeOut();
    }
  });
}

//Aboutページの登録ログインリード表示
$(function() {
  if ($("#scroll").length != 0) {
    setTimeout(function() {
      $("#scroll").slideDown();
    }, 3000);

    if ($("#about-lead").length != 0) {
      setTimeout(function() {
        var point = $("#about-lead").offset().top - 400;
        scrollOut($("#scroll"), point);
      }, 3100);
    }
  }
  return false;
});

$(function() {
  if ($("#popup").length != 0) {
    setTimeout(function() {
      $("#popup").slideDown();
    }, 1000);
  }

  $("#remove").on("click", function(e) {
    e.preventDefault();
    $("#popup").css("display", "none");
  });
});
