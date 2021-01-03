// To parse this JSON data, do
//
//     final homeResponse = homeResponseFromJson(jsonString);

import 'dart:convert';

class HomeResponse {
  HomeResponse({
    this.containers,
    this.contents,
    this.validDuration,
    this.groupCursor,
  });

  final List<Container> containers;
  final Map<String, Content> contents;
  final int validDuration;
  final int groupCursor;

  factory HomeResponse.fromRawJson(String str) =>
      HomeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
        containers: json["containers"] == null
            ? null
            : List<Container>.from(
                json["containers"].map((x) => Container.fromJson(x))),
        contents: json["contents"] == null
            ? null
            : Map.from(json["contents"]).map(
                (k, v) => MapEntry<String, Content>(k, Content.fromJson(v))),
        validDuration:
            json["valid_duration"] == null ? null : json["valid_duration"],
        groupCursor: json["groupCursor"] == null ? null : json["groupCursor"],
      );

  Map<String, dynamic> toJson() => {
        "containers": containers == null
            ? null
            : List<dynamic>.from(containers.map((x) => x.toJson())),
        "contents": contents == null
            ? null
            : Map.from(contents)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "valid_duration": validDuration == null ? null : validDuration,
        "groupCursor": groupCursor == null ? null : groupCursor,
      };
}

class SingleContainerResponse
{
  SingleContainerResponse({
    this.container,
    this.contents,
    this.validDuration,
  });

  final Container container;
  final Map<String, Content> contents;
  final int validDuration;


  factory SingleContainerResponse.fromRawJson(String str) => SingleContainerResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleContainerResponse.fromJson(Map<String, dynamic> json) => SingleContainerResponse(
    container: json["container"] == null ? null : Container.fromJson(json["container"]),
    contents: json["contents"] == null ? null : Map.from(json["contents"]).map((k, v) => MapEntry<String, Content>(k, Content.fromJson(v))),
    validDuration: json["valid_duration"] == null ? null : json["valid_duration"],
  );

  Map<String, dynamic> toJson() => {
    "container": container == null ? null : container.toJson(),
    "contents": contents == null ? null : Map.from(contents).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "valid_duration": validDuration == null ? null : validDuration,
  };
}

class Container {
  Container({
    this.id,
    this.type,
    this.title,
    this.description,
    this.thumbnail,
    this.children,
    this.cursor,
    this.slug,
    this.logo,
    this.background,
    this.tags,
  });

  final String id;
  final String type;
  final String title;
  final String description;
  final String thumbnail;
  final List<String> children;
  final int cursor;
  final String slug;
  final String logo;
  final String background;
  final List<String> tags;

  factory Container.fromRawJson(String str) =>
      Container.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Container.fromJson(Map<String, dynamic> json) => Container(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        children: json["children"] == null
            ? null
            : List<String>.from(json["children"].map((x) => x)),
        cursor: json["cursor"] == null ? null : json["cursor"],
        slug: json["slug"] == null ? null : json["slug"],
        logo: json["logo"] == null ? null : json["logo"],
        background: json["background"] == null ? null : json["background"],
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x)),
        "cursor": cursor == null ? null : cursor,
        "slug": slug == null ? null : slug,
        "logo": logo == null ? null : logo,
        "background": background == null ? null : background,
        "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
      };
}

class Content {
  Content(
      {this.id,
      this.type,
      this.title,
      this.tags,
      this.year,
      this.description,
      this.publisherId,
      this.importId,
      this.ratings,
      this.actors,
      this.directors,
      this.availabilityDuration,
      this.images,
      this.hasSubtitle,
      this.imdbId,
      this.partnerId,
      this.lang,
      this.country,
      this.policyMatch,
      this.updatedAt,
      this.awards,
      this.videoResources,
      this.posterarts,
      this.thumbnails,
      this.heroImages,
      this.landscapeImages,
      this.backgrounds,
      this.gnFields,
      this.detailedType,
      this.needsLogin,
      this.subtitles,
      this.hasTrailer,
      this.canonicalId,
      this.versionId,
      this.validDuration,
      this.duration,
      this.creditCuepoints,
      this.url,
      this.monetization,
      this.availabilityStarts,
      this.availabilityEnds,
      this.trailers,
      this.seriesId,
      this.children,
      this.isRecurring});

  final String id;
  final String type;
  final String title;
  final List<String> tags;
  final int year;
  final String description;
  final String publisherId;
  final String importId;
  final List<Rating> ratings;
  final List<String> actors;
  final List<String> directors;
  final int availabilityDuration;
  final dynamic images;
  final bool hasSubtitle;
  final String imdbId;
  final dynamic partnerId;
  final String lang;
  final String country;
  final bool policyMatch;
  final String updatedAt;
  final dynamic awards;
  final List<VideoResource> videoResources;
  final List<String> posterarts;
  final List<String> thumbnails;
  final List<String> heroImages;
  final List<String> landscapeImages;
  final List<String> backgrounds;
  final dynamic gnFields;
  final String detailedType;
  final bool needsLogin;
  final List<Subtitle> subtitles;
  final bool hasTrailer;
  final String canonicalId;
  final String versionId;
  final int validDuration;
  final int duration;
  final dynamic creditCuepoints;
  final String url;
  final dynamic monetization;
  final String availabilityStarts;
  final dynamic availabilityEnds;
  final List<dynamic> trailers;
  final bool isRecurring;
  final List<Child> children;
  final String seriesId;

  factory Content.fromRawJson(String str) => Content.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        title: json["title"] == null ? null : json["title"],
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
        year: json["year"] == null ? null : json["year"],
        description: json["description"] == null ? null : json["description"],
        publisherId: json["publisher_id"] == null ? null : json["publisher_id"],
        importId: json["import_id"] == null ? null : json["import_id"],
        ratings: json["ratings"] == null
            ? null
            : List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
        actors: json["actors"] == null
            ? null
            : List<String>.from(json["actors"].map((x) => x)),
        directors: json["directors"] == null
            ? null
            : List<String>.from(json["directors"].map((x) => x)),
        availabilityDuration: json["availability_duration"] == null
            ? null
            : json["availability_duration"],
        images: json["images"] == null ? null : json["images"],
        hasSubtitle: json["has_subtitle"] == null ? null : json["has_subtitle"],
        imdbId: json["imdb_id"] == null ? null : json["imdb_id"],
        partnerId: json["partner_id"],
        lang: json["lang"] == null ? null : json["lang"],
        country: json["country"] == null ? null : json["country"],
        policyMatch: json["policy_match"] == null ? null : json["policy_match"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        awards: json["awards"] == null ? null : json["awards"],
        isRecurring: json["is_recurring"] == null ? null : json["is_recurring"],
        children: json["children"] == null
            ? null
            : List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
        videoResources: json["video_resources"] == null
            ? null
            : List<VideoResource>.from(
                json["video_resources"].map((x) => VideoResource.fromJson(x))),
        posterarts: json["posterarts"] == null
            ? null
            : List<String>.from(json["posterarts"].map((x) => x)),
        thumbnails: json["thumbnails"] == null
            ? null
            : List<String>.from(json["thumbnails"].map((x) => x)),
        heroImages: json["hero_images"] == null
            ? null
            : List<String>.from(json["hero_images"].map((x) => x)),
        landscapeImages: json["landscape_images"] == null
            ? null
            : List<String>.from(json["landscape_images"].map((x) => x)),
        backgrounds: json["backgrounds"] == null
            ? null
            : List<String>.from(json["backgrounds"].map((x) => x)),
        gnFields: json["gn_fields"],
        detailedType:
            json["detailed_type"] == null ? null : json["detailed_type"],
        needsLogin: json["needs_login"] == null ? null : json["needs_login"],
        subtitles: json["subtitles"] == null
            ? null
            : List<Subtitle>.from(
                json["subtitles"].map((x) => Subtitle.fromJson(x))),
        hasTrailer: json["has_trailer"] == null ? null : json["has_trailer"],
        canonicalId: json["canonical_id"] == null ? null : json["canonical_id"],
        versionId: json["version_id"] == null ? null : json["version_id"],
        validDuration:
            json["valid_duration"] == null ? null : json["valid_duration"],
        duration: json["duration"] == null ? null : json["duration"],
        creditCuepoints:
            json["credit_cuepoints"] == null ? null : json["credit_cuepoints"],
        url: json["url"] == null ? null : json["url"],
        monetization:
            json["monetization"] == null ? null : json["monetization"],
        availabilityStarts: json["availability_starts"] == null
            ? null
            : json["availability_starts"],
        availabilityEnds: json["availability_ends"],
        trailers: json["trailers"] == null
            ? null
            : List<dynamic>.from(json["trailers"].map((x) => x)),
        seriesId: json["series_id"] == null ? null : json["series_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "title": title == null ? null : title,
        "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
        "year": year == null ? null : year,
        "description": description == null ? null : description,
        "publisher_id": publisherId == null ? null : publisherId,
        "import_id": importId == null ? null : importId,
        "ratings": ratings == null
            ? null
            : List<dynamic>.from(ratings.map((x) => x.toJson())),
        "actors":
            actors == null ? null : List<dynamic>.from(actors.map((x) => x)),
        "directors": directors == null
            ? null
            : List<dynamic>.from(directors.map((x) => x)),
        "availability_duration":
            availabilityDuration == null ? null : availabilityDuration,
        "images": images == null ? null : images.toJson(),
        "has_subtitle": hasSubtitle == null ? null : hasSubtitle,
        "imdb_id": imdbId == null ? null : imdbId,
        "partner_id": partnerId,
        "lang": lang == null ? null : lang,
        "country": country == null ? null : country,
        "policy_match": policyMatch == null ? null : policyMatch,
        "updated_at": updatedAt == null ? null : updatedAt,
        "awards": awards == null ? null : awards.toJson(),
        "is_recurring": isRecurring == null ? null : isRecurring,
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x.toJson())),
        "video_resources": videoResources == null
            ? null
            : List<dynamic>.from(videoResources.map((x) => x.toJson())),
        "posterarts": posterarts == null
            ? null
            : List<dynamic>.from(posterarts.map((x) => x)),
        "thumbnails": thumbnails == null
            ? null
            : List<dynamic>.from(thumbnails.map((x) => x)),
        "hero_images": heroImages == null
            ? null
            : List<dynamic>.from(heroImages.map((x) => x)),
        "landscape_images": landscapeImages == null
            ? null
            : List<dynamic>.from(landscapeImages.map((x) => x)),
        "backgrounds": backgrounds == null
            ? null
            : List<dynamic>.from(backgrounds.map((x) => x)),
        "gn_fields": gnFields,
        "detailed_type": detailedType == null ? null : detailedType,
        "needs_login": needsLogin == null ? null : needsLogin,
        "subtitles": subtitles == null
            ? null
            : List<dynamic>.from(subtitles.map((x) => x.toJson())),
        "has_trailer": hasTrailer == null ? null : hasTrailer,
        "canonical_id": canonicalId == null ? null : canonicalId,
        "version_id": versionId == null ? null : versionId,
        "valid_duration": validDuration == null ? null : validDuration,
        "duration": duration == null ? null : duration,
        "credit_cuepoints":
            creditCuepoints == null ? null : creditCuepoints.toJson(),
        "url": url == null ? null : url,
        "monetization": monetization == null ? null : monetization.toJson(),
        "availability_starts":
            availabilityStarts == null ? null : availabilityStarts,
        "availability_ends": availabilityEnds,
        "trailers": trailers == null
            ? null
            : List<dynamic>.from(trailers.map((x) => x)),
        "series_id": seriesId == null ? null : seriesId,
      };
}

class Child {
  Child({
    this.id,
    this.type,
    this.title,
    this.posterarts,
    this.children,
  });

  final String id;
  final String type;
  final String title;
  final List<dynamic> posterarts;
  final List<Content> children;

  factory Child.fromRawJson(String str) => Child.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        title: json["title"] == null ? null : json["title"],
        posterarts: json["posterarts"] == null
            ? null
            : List<dynamic>.from(json["posterarts"].map((x) => x)),
        children: json["children"] == null
            ? null
            : List<Content>.from(
                json["children"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "title": title == null ? null : title,
        "posterarts": posterarts == null
            ? null
            : List<dynamic>.from(posterarts.map((x) => x)),
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x.toJson())),
      };
}

class Rating {
  Rating({
    this.system,
    this.value,
    this.code,
  });

  final String system;
  final String value;
  final String code;

  factory Rating.fromRawJson(String str) => Rating.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        system: json["system"] == null ? null : json["system"],
        value: json["value"] == null ? null : json["value"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "system": system == null ? null : system,
        "value": value == null ? null : value,
        "code": code == null ? null : code,
      };
}

class Subtitle {
  Subtitle({
    this.lang,
    this.url,
  });

  final String lang;
  final String url;

  factory Subtitle.fromRawJson(String str) =>
      Subtitle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subtitle.fromJson(Map<String, dynamic> json) => Subtitle(
        lang: json["lang"] == null ? null : json["lang"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "lang": lang == null ? null : lang,
        "url": url == null ? null : url,
      };
}

class VideoResource {
  VideoResource({
    this.manifest,
    this.type,
  });

  final Manifest manifest;
  final String type;

  factory VideoResource.fromRawJson(String str) =>
      VideoResource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoResource.fromJson(Map<String, dynamic> json) => VideoResource(
        manifest: json["manifest"] == null
            ? null
            : Manifest.fromJson(json["manifest"]),
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "manifest": manifest == null ? null : manifest.toJson(),
        "type": type == null ? null : type,
      };
}

class Manifest {
  Manifest({
    this.url,
    this.duration,
  });

  final String url;
  final int duration;

  factory Manifest.fromRawJson(String str) =>
      Manifest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Manifest.fromJson(Map<String, dynamic> json) => Manifest(
        url: json["url"] == null ? null : json["url"],
        duration: json["duration"] == null ? null : json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "duration": duration == null ? null : duration,
      };
}
