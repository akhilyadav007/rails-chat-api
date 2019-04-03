require 'rails_helper'

RSpec.describe QueryChatBetweenUsers do
  let(:user1) { create :user }
  let(:user2) { create :user }
  
  describe '#call' do
    context 'when chat between users already exists' do
      let(:chat) { create :chat }
      
      before do
        create :join, joinable: chat, user: user1
        create :join, joinable: chat, user: user2
      end
      
      it 'returns the chat object' do
        chat_between_users = described_class.new(user1.id, user2.id).call
        expect(chat_between_users).to eq(chat)
      end
    end
    
    context 'when chat between users doesn\'t exist' do
      it 'creates a new chat object' do
        expect { described_class.new(user1.id, user2.id).call }
          .to change { Chat.count }.by(1)
      end
    end
    
    context 'raises a RecordNotFound error' do
      it 'doesn\'t create a new chat' do
        expect { described_class.new(user1.id, 200).call }
          .to raise_error(ExceptionHandler::BadRequest, 'Bad request')
      end
    end
    
    context 'raises a BadRequest error' do
      it 'doesn\'t create a new chat' do
        expect { described_class.new(user1.id, user1.id).call }
          .to raise_error(ExceptionHandler::BadRequest, 'Bad request')
      end
    end
  end
end