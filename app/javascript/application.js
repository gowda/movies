/* eslint no-console:0 */

import $ from 'jquery';
import { createConsumer } from "@rails/actioncable";
import { setupDropdownClickHandlers } from './navbar';
import { createImportHandler, createUpdateHandler } from './datasets/event-handlers';
import { handleMessage } from './datasets/message-handler';

$(() => {
  console.log('hello from webpacker');

  setupDropdownClickHandlers();

  $('.dataset-import').each((index, node) => {
    const name = $(node).data('name');
    $(node).click(createImportHandler(name));
  });

  $('.dataset-update').each((index, node) => {
    const name = $(node).data('name');
    $(node).click(createUpdateHandler(name));
  });

  const consumer = createConsumer('/cable');
  consumer.subscriptions.create(
    { channel: "DatasetsChannel" },
    {
      collection: () => $("[data-channel='comments']"),
      connected: () => console.log('connected'),
      received: ({body}) => handleMessage(body)
    }
  )
})
