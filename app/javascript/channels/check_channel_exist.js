import consumer from "./consumer"

export default function channelExist(channel, label_id = null, id = null) {
  let index;

  if (label_id && id) {
    index = consumer.subscriptions['subscriptions'].findIndex((el) => el.identifier === '{\"channel\":\"' + channel + '\",\"' + label_id + '\":' + id +'}');
  } else {
    index = consumer.subscriptions['subscriptions'].findIndex((el) => el.identifier === '{\"channel\":\"' + channel + '\"}');
  }

  return index > -1;
}
