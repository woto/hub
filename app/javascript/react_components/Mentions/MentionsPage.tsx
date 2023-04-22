import * as React from 'react';
import MentionsItem from './MentionsItem1';

function MentionsPage({
  page, pageIdx,
} : {
  page: any,
  pageIdx: any,
}) {
  return page.mentions.map((mention, _) => (
    <MentionsItem
      key={mention._id}
      mentionId={mention._id}
      title={mention._source.title}
      image={
                (mention._source.image
                && mention._source.image.length > 0
                && mention._source.image[0]) || null
              }
      url={mention._source.url}
      entities={mention._source.entities}
      topics={mention._source.topics}
      publishedAt={mention._source.published_at}
      slug={mention._source.slug}
    />
  ));
}

export default React.memo(MentionsPage);
