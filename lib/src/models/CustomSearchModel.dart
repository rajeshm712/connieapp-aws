// Created by Sanjeev Sangral on 22/10/20.
class CustomSearch {
  String kind;
  Url url;
  Queries queries;
  Context context;
  SearchInformation searchInformation;
  List<Items> items = [];

  CustomSearch(
      {this.kind,
      this.url,
      this.queries,
      this.context,
      this.searchInformation,
      this.items});

  CustomSearch.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    url = json['url'] != null ? new Url.fromJson(json['url']) : null;
    queries =
        json['queries'] != null ? new Queries.fromJson(json['queries']) : null;
    context =
        json['context'] != null ? new Context.fromJson(json['context']) : null;
    searchInformation = json['searchInformation'] != null
        ? new SearchInformation.fromJson(json['searchInformation'])
        : null;
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    if (this.url != null) {
      data['url'] = this.url.toJson();
    }
    if (this.queries != null) {
      data['queries'] = this.queries.toJson();
    }
    if (this.context != null) {
      data['context'] = this.context.toJson();
    }
    if (this.searchInformation != null) {
      data['searchInformation'] = this.searchInformation.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Url {
  String type;
  String template;

  Url({this.type, this.template});

  Url.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    template = json['template'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['template'] = this.template;
    return data;
  }
}

class Queries {
  List<Request> request = [];

  Queries({this.request});

  Queries.fromJson(Map<String, dynamic> json) {
    if (json['request'] != null) {
      request = [];
      json['request'].forEach((v) {
        request.add(new Request.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.request != null) {
      data['request'] = this.request.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Request {
  String title;
  String totalResults;
  String searchTerms;
  int count;
  int startIndex;
  String inputEncoding;
  String outputEncoding;
  String safe;
  String cx;

  Request(
      {this.title,
      this.totalResults,
      this.searchTerms,
      this.count,
      this.startIndex,
      this.inputEncoding,
      this.outputEncoding,
      this.safe,
      this.cx});

  Request.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    totalResults = json['totalResults'];
    searchTerms = json['searchTerms'];
    count = json['count'];
    startIndex = json['startIndex'];
    inputEncoding = json['inputEncoding'];
    outputEncoding = json['outputEncoding'];
    safe = json['safe'];
    cx = json['cx'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['totalResults'] = this.totalResults;
    data['searchTerms'] = this.searchTerms;
    data['count'] = this.count;
    data['startIndex'] = this.startIndex;
    data['inputEncoding'] = this.inputEncoding;
    data['outputEncoding'] = this.outputEncoding;
    data['safe'] = this.safe;
    data['cx'] = this.cx;
    return data;
  }
}

class Context {
  String title;

  Context({this.title});

  Context.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    return data;
  }
}

class SearchInformation {
  double searchTime;
  String formattedSearchTime;
  String totalResults;
  String formattedTotalResults;

  SearchInformation(
      {this.searchTime,
      this.formattedSearchTime,
      this.totalResults,
      this.formattedTotalResults});

  SearchInformation.fromJson(Map<String, dynamic> json) {
    searchTime = json['searchTime'];
    formattedSearchTime = json['formattedSearchTime'];
    totalResults = json['totalResults'];
    formattedTotalResults = json['formattedTotalResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchTime'] = this.searchTime;
    data['formattedSearchTime'] = this.formattedSearchTime;
    data['totalResults'] = this.totalResults;
    data['formattedTotalResults'] = this.formattedTotalResults;
    return data;
  }
}

class Items {
  String kind;
  String title;
  String htmlTitle;
  String link;
  String displayLink;
  String snippet;
  String htmlSnippet;
  String formattedUrl;
  String htmlFormattedUrl;
  Pagemap pagemap;
  String cacheId;

  Items(
      {this.kind,
      this.title,
      this.htmlTitle,
      this.link,
      this.displayLink,
      this.snippet,
      this.htmlSnippet,
      this.formattedUrl,
      this.htmlFormattedUrl,
      this.pagemap,
      this.cacheId});

  Items.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    title = json['title'];
    htmlTitle = json['htmlTitle'];
    link = json['link'];
    displayLink = json['displayLink'];
    snippet = json['snippet'];
    htmlSnippet = json['htmlSnippet'];
    formattedUrl = json['formattedUrl'];
    htmlFormattedUrl = json['htmlFormattedUrl'];
    pagemap =
        json['pagemap'] != null ? new Pagemap.fromJson(json['pagemap']) : null;
    cacheId = json['cacheId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['title'] = this.title;
    data['htmlTitle'] = this.htmlTitle;
    data['link'] = this.link;
    data['displayLink'] = this.displayLink;
    data['snippet'] = this.snippet;
    data['htmlSnippet'] = this.htmlSnippet;
    data['formattedUrl'] = this.formattedUrl;
    data['htmlFormattedUrl'] = this.htmlFormattedUrl;
    if (this.pagemap != null) {
      data['pagemap'] = this.pagemap.toJson();
    }
    data['cacheId'] = this.cacheId;
    return data;
  }
}

class Pagemap {
  List<CseThumbnail> cseThumbnail = [];
  List<Metatags> metatags = [];
  List<CseImage> cseImage = [];
  List<Organization> organization = [];
  List<Educationalorganization> educationalorganization = [];

  Pagemap(
      {this.cseThumbnail,
      this.metatags,
      this.cseImage,
      this.organization,
      this.educationalorganization});

  Pagemap.fromJson(Map<String, dynamic> json) {
    if (json['cse_thumbnail'] != null) {
      cseThumbnail = [];
      json['cse_thumbnail'].forEach((v) {
        cseThumbnail.add(new CseThumbnail.fromJson(v));
      });
    }
    if (json['metatags'] != null) {
      metatags = [];
      json['metatags'].forEach((v) {
        metatags.add(new Metatags.fromJson(v));
      });
    }
    if (json['cse_image'] != null) {
      cseImage = [];
      json['cse_image'].forEach((v) {
        cseImage.add(new CseImage.fromJson(v));
      });
    }
    if (json['organization'] != null) {
      organization = [];
      json['organization'].forEach((v) {
        organization.add(new Organization.fromJson(v));
      });
    }
    if (json['educationalorganization'] != null) {
      educationalorganization = [];
      json['educationalorganization'].forEach((v) {
        educationalorganization.add(new Educationalorganization.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cseThumbnail != null) {
      data['cse_thumbnail'] = this.cseThumbnail.map((v) => v.toJson()).toList();
    }
    if (this.metatags != null) {
      data['metatags'] = this.metatags.map((v) => v.toJson()).toList();
    }
    if (this.cseImage != null) {
      data['cse_image'] = this.cseImage.map((v) => v.toJson()).toList();
    }
    if (this.organization != null) {
      data['organization'] = this.organization.map((v) => v.toJson()).toList();
    }
    if (this.educationalorganization != null) {
      data['educationalorganization'] =
          this.educationalorganization.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CseThumbnail {
  String src;
  String width;
  String height;

  CseThumbnail({this.src, this.width, this.height});

  CseThumbnail.fromJson(Map<String, dynamic> json) {
    src = json['src'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this.src;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Metatags {
  String ogImage;
  String ogType;
  String twitterCard;
  String twitterTitle;
  String alIosAppName;
  String platformWorker;
  String ogTitle;
  String alAndroidPackage;
  String pagekey;
  String locale;
  String alIosUrl;
  String ogDescription;
  String alIosAppStoreId;
  String platform;
  String twitterImage;
  String alAndroidUrl;
  String profileLastName;
  String twitterSite;
  String viewport;
  String litmsprofilename;
  String twitterDescription;
  String profileFirstName;
  String ogUrl;
  String alAndroidAppName;
  String ogSiteName;
  String i18nScope;
  String csrfToken;
  String metricBase;
  String csrfParam;
  String spokeName;
  String ogAdmins;
  String msvalidate01;
  String profileUsername;
  String sToken;
  String yandexVerification;
  String fragment;
  String fbAppId;
  String wbWebmaster;
  String sCachebuster;
  String msapplicationTilecolor;
  String msapplicationConfig;
  String ogImageAlt;
  String ogImageWidth;
  String themeColor;
  String ogImageHeight;
  String ogImageType;
  String title;
  String msapplicationTileimage;
  String twitterCreator;
  String articleModifiedTime;
  String ogLocale;
  String ogKeywords;
  String nextHeadCount;

  Metatags(
      {this.ogImage,
      this.ogType,
      this.twitterCard,
      this.twitterTitle,
      this.alIosAppName,
      this.platformWorker,
      this.ogTitle,
      this.alAndroidPackage,
      this.pagekey,
      this.locale,
      this.alIosUrl,
      this.ogDescription,
      this.alIosAppStoreId,
      this.platform,
      this.twitterImage,
      this.alAndroidUrl,
      this.profileLastName,
      this.twitterSite,
      this.viewport,
      this.litmsprofilename,
      this.twitterDescription,
      this.profileFirstName,
      this.ogUrl,
      this.alAndroidAppName,
      this.ogSiteName,
      this.i18nScope,
      this.csrfToken,
      this.metricBase,
      this.csrfParam,
      this.spokeName,
      this.ogAdmins,
      this.msvalidate01,
      this.profileUsername,
      this.sToken,
      this.yandexVerification,
      this.fragment,
      this.fbAppId,
      this.wbWebmaster,
      this.sCachebuster,
      this.msapplicationTilecolor,
      this.msapplicationConfig,
      this.ogImageAlt,
      this.ogImageWidth,
      this.themeColor,
      this.ogImageHeight,
      this.ogImageType,
      this.title,
      this.msapplicationTileimage,
      this.twitterCreator,
      this.articleModifiedTime,
      this.ogLocale,
      this.ogKeywords,
      this.nextHeadCount});

  Metatags.fromJson(Map<String, dynamic> json) {
    ogImage = json['og:image'];
    ogType = json['og:type'];
    twitterCard = json['twitter:card'];
    twitterTitle = json['twitter:title'];
    alIosAppName = json['al:ios:app_name'];
    platformWorker = json['platform-worker'];
    ogTitle = json['og:title'];
    alAndroidPackage = json['al:android:package'];
    pagekey = json['pagekey'];
    locale = json['locale'];
    alIosUrl = json['al:ios:url'];
    ogDescription = json['og:description'];
    alIosAppStoreId = json['al:ios:app_store_id'];
    platform = json['platform'];
    twitterImage = json['twitter:image'];
    alAndroidUrl = json['al:android:url'];
    profileLastName = json['profile:last_name'];
    twitterSite = json['twitter:site'];
    viewport = json['viewport'];
    litmsprofilename = json['litmsprofilename'];
    twitterDescription = json['twitter:description'];
    profileFirstName = json['profile:first_name'];
    ogUrl = json['og:url'];
    alAndroidAppName = json['al:android:app_name'];
    ogSiteName = json['og:site_name'];
    i18nScope = json['i18n_scope'];
    csrfToken = json['csrf-token'];
    metricBase = json['metric_base'];
    csrfParam = json['csrf-param'];
    spokeName = json['spoke_name'];
    ogAdmins = json['og:admins'];
    msvalidate01 = json['msvalidate.01'];
    profileUsername = json['profile:username'];
    sToken = json['_token'];
    yandexVerification = json['yandex-verification'];
    fragment = json['fragment'];
    fbAppId = json['fb:app_id'];
    wbWebmaster = json['wb:webmaster'];
    sCachebuster = json['_cachebuster'];
    msapplicationTilecolor = json['msapplication-tilecolor'];
    msapplicationConfig = json['msapplication-config'];
    ogImageAlt = json['og:image:alt'];
    ogImageWidth = json['og:image:width'];
    themeColor = json['theme-color'];
    ogImageHeight = json['og:image:height'];
    ogImageType = json['og:image:type'];
    title = json['title'];
    msapplicationTileimage = json['msapplication-tileimage'];
    twitterCreator = json['twitter:creator'];
    articleModifiedTime = json['article:modified_time'];
    ogLocale = json['og:locale'];
    ogKeywords = json['og:keywords'];
    nextHeadCount = json['next-head-count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['og:image'] = this.ogImage;
    data['og:type'] = this.ogType;
    data['twitter:card'] = this.twitterCard;
    data['twitter:title'] = this.twitterTitle;
    data['al:ios:app_name'] = this.alIosAppName;
    data['platform-worker'] = this.platformWorker;
    data['og:title'] = this.ogTitle;
    data['al:android:package'] = this.alAndroidPackage;
    data['pagekey'] = this.pagekey;
    data['locale'] = this.locale;
    data['al:ios:url'] = this.alIosUrl;
    data['og:description'] = this.ogDescription;
    data['al:ios:app_store_id'] = this.alIosAppStoreId;
    data['platform'] = this.platform;
    data['twitter:image'] = this.twitterImage;
    data['al:android:url'] = this.alAndroidUrl;
    data['profile:last_name'] = this.profileLastName;
    data['twitter:site'] = this.twitterSite;
    data['viewport'] = this.viewport;
    data['litmsprofilename'] = this.litmsprofilename;
    data['twitter:description'] = this.twitterDescription;
    data['profile:first_name'] = this.profileFirstName;
    data['og:url'] = this.ogUrl;
    data['al:android:app_name'] = this.alAndroidAppName;
    data['og:site_name'] = this.ogSiteName;
    data['i18n_scope'] = this.i18nScope;
    data['csrf-token'] = this.csrfToken;
    data['metric_base'] = this.metricBase;
    data['csrf-param'] = this.csrfParam;
    data['spoke_name'] = this.spokeName;
    data['og:admins'] = this.ogAdmins;
    data['msvalidate.01'] = this.msvalidate01;
    data['profile:username'] = this.profileUsername;
    data['_token'] = this.sToken;
    data['yandex-verification'] = this.yandexVerification;
    data['fragment'] = this.fragment;
    data['fb:app_id'] = this.fbAppId;
    data['wb:webmaster'] = this.wbWebmaster;
    data['_cachebuster'] = this.sCachebuster;
    data['msapplication-tilecolor'] = this.msapplicationTilecolor;
    data['msapplication-config'] = this.msapplicationConfig;
    data['og:image:alt'] = this.ogImageAlt;
    data['og:image:width'] = this.ogImageWidth;
    data['theme-color'] = this.themeColor;
    data['og:image:height'] = this.ogImageHeight;
    data['og:image:type'] = this.ogImageType;
    data['title'] = this.title;
    data['msapplication-tileimage'] = this.msapplicationTileimage;
    data['twitter:creator'] = this.twitterCreator;
    data['article:modified_time'] = this.articleModifiedTime;
    data['og:locale'] = this.ogLocale;
    data['og:keywords'] = this.ogKeywords;
    data['next-head-count'] = this.nextHeadCount;
    return data;
  }
}

class CseImage {
  String src;

  CseImage({this.src});

  CseImage.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this.src;
    return data;
  }
}

class Organization {
  String image;
  String articlebody;
  String jobtitle;
  String name;
  String url;

  Organization(
      {this.image, this.articlebody, this.jobtitle, this.name, this.url});

  Organization.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    articlebody = json['articlebody'];
    jobtitle = json['jobtitle'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['articlebody'] = this.articlebody;
    data['jobtitle'] = this.jobtitle;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Educationalorganization {
  String name;

  Educationalorganization({this.name});

  Educationalorganization.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
