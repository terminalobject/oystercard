require './lib/oystercard.rb'
describe Oystercard do

	let(:card) {described_class.new}

	it "expects the card to have a balance of 0 when initialized" do  
		expect(card.balance).to eq 0
	end 

	describe "#top_up" do 
		it "increases the card balance by a specified amount" do 
			card.top_up(5)
			expect(card.balance).to eq 5 
		end 
		context "If top up makes balance exceed limit of £90"
		it "raises an error" do
			card.top_up(Oystercard::CARD_LIMIT)
			expect{card.top_up(1)}.to raise_error("Total balance cannot exceed £90")
		end
	end 
	describe "#deduct" do 
		it "deducts some amount from the card balance" do
			random_amount = rand(1..90)
			card.top_up(random_amount)
			expect(card.deduct(random_amount)).to eq 0 
		end 
	end 
	describe "#touch_in" do
		it "changes card status to in use when touched in" do
			card.top_up(10)
			expect(card.touch_in).to eq(true)
		end
	end
	describe "#in_journey?" do
		it "tells whether a card is in use" do
			#allow(card).to receive_message_chain(:top_up,:touch_in)
			card.touch_in
			expect(card.in_journey?).to eq true
		end 
	end 
	describe "#touch_out" do
		it "changes card status to not in use" do
			card.touch_in
			card.touch_out
			expect(card).not_to be_in_journey
		end 
	end 
end